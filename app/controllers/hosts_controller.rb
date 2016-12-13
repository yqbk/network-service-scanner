require_relative '../../app/controllers/network/scanner'
require_relative '../../app/controllers/network/fast_scann'
require_relative '../../app/controllers/network/telnet'

require 'net/ping'



class HostsController < ApplicationController

  # todo OS detection
  # todo Implement full scann of the network with multiple methods , nmap -sP
  # todo Navbar in the top of page
  # todo refresh chartkick on change or add generate chart button
  # todo hosts map with d3.js
  # todo refactor scanner to implement inheritance

  # todo po kolei jakie skany na jakie porty jak w nmap

#   todo telnet udp i ftp
#   todo node diagram i speed chart
#   todo button fast scann on second tab



  def component
    @hosts = Host.all
  end

  def index
    @hosts = Host.all
  end

  def destroy
    @host = Host.find(params[:id])
    @host.destroy
    head :no_content
  end

  def initScanner(name)

    src = 1998 #change here
    timeout_value = 2
    tries = 10
    sleep_time = 0

    if name == 'syn'
      return SYN_scanner.new(src, timeout_value, tries, sleep_time)
    elsif name == 'fin'
      return FIN_scanner.new(src, timeout_value, tries, sleep_time)
    elsif name == 'udp'
      timeout_value = 22
      tries = 4
      sleep_time = 5

      return UDP_scanner.new(src, timeout_value, tries, sleep_time)
    else
      puts "initScanner error"
      return
    end

  end

  def scann()

    host_addr = params[:host][:IP]
    port_nr = params[:host][:port].to_i
    scann_type = params[:host][:scann_type]
    status = '?'
    scann_time = 0


    if scann_type == 'syn'
      @syn_scanner.set_dst_host(host_addr)
      @syn_scanner.set_dst_port(port_nr)
      scann_time = Benchmark.realtime{
        status = @syn_scanner.scann
      }
    elsif scann_type == 'fin'
      @fin_scanner.set_dst_host(host_addr)
      @fin_scanner.set_dst_port(port_nr)
      scann_time = Benchmark.realtime {
        status = @fin_scanner.scann
      }
    elsif scann_type == 'udp'
      @udp_scanner.set_dst_host(host_addr)
      @udp_scanner.set_dst_port(port_nr)
      scann_time = Benchmark.realtime {
        status = @udp_scanner.scann
      }
    elsif scann_type == 'xmas'
      scann_time = Benchmark.realtime {
        # status = scanner.tcp_xmas_scan(host_addr, port_nr)
      }
    elsif scann_type == 'null'
      scann_time = Benchmark.realtime {
        # status = scanner.tcp_null_scan(host_addr, port_nr)
      }
    elsif scann_type == 'ping'
      scann_time = Benchmark.realtime {

        if ping(host_addr)
          status = "up"
        else
          status = "down"
        end
      }
    elsif scann_type == 'simple'
      scann_time = Benchmark.realtime {

      #  puts "dziala"
      #   todo save hosts to database
      #
      #  fast_scanner = FastScann.new
      #  fast_scanner.performFastScann(host_addr)
      }
    elsif scann_type == 'clear'
      Host.delete_all
    else
      begin
        redirect_to hosts_url, alert: 'incorrect type'
        return
      end
    end

    if status != "down"
      service = @teln.connect(host_addr, port_nr)
    end

    Host.new(:scan_id => @hosts.count, :IP => host_addr, :port => port_nr, :status => status, :scann_type => scann_type, :scann_time => scann_time.round(5).to_s, :service => service)

  end



  def ping(host)
    check = Net::Ping::External.new(host)
    if !check.ping?
      src = 1998
      timeout_value = 5
      tries = 10
      sleep_time = 0

      scanner = ACK_scanner.new(host, 80, src, timeout_value, tries, sleep_time)
      status = scanner.scann

      if status != "filtered"
        return true
      else
        return false
      end

    else
      return true
    end

  end

  def init
    if @syn_scanner == nil
      @syn_scanner = initScanner('syn')
    end

    if @fin_scanner == nil
      @fin_scanner = initScanner('fin')
    end

    if @udp_scanner == nil
      @udp_scanner = initScanner('udp')
    end

    if @teln == nil
      @teln = Telnet.new
    end
  end

  def create
    init()
    @hosts = Host.all

    begin
      @host = scann()
      @host.save
    rescue NoMethodError
      nil
    end

    # Host.delete_all

    render_host()
  end

  private


  def host_params
    params.require(:host).permit(:IP, :port)
  end

  def render_host
    if @host.save
      render json: @host
    else
      render json: @host.errors, status: :unprocessable_entity
    end
  end
end
