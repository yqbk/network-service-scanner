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

  def scann()

    host_addr = params[:host][:IP]
    port_nr = params[:host][:port].to_i
    scann_type = params[:host][:scann_type]
    status = '?'
    scann_time = 0

    if scann_type == 'syn'
      scann_time = Benchmark.realtime{

        src = 1998
        timeout_value = 5
        tries = 10
        sleep_time = 0

        scanner = SYN_scanner.new(host_addr, port_nr, src, timeout_value, tries, sleep_time)
        status = scanner.scann
      }
    elsif scann_type == 'udp'
      scann_time = Benchmark.realtime {

        dst = 53
        src = 1998
        timeout_value = 22
        tries = 4
        sleep_time = 5

        scanner = UDP_scanner.new(host_addr, dst, src, timeout_value, tries, sleep_time)
        scanner.set_dst_port(port_nr)

        status = scanner.scann
      }
    elsif scann_type == 'fin'
      scann_time = Benchmark.realtime {

        src = 1998
        timeout_value = 5
        tries = 10
        sleep_time = 0

        scanner = FIN_scanner.new(host_addr, port_nr, src, timeout_value, tries, sleep_time)
        status = scanner.scann
      }
    elsif scann_type == 'xmas'
      scann_time = Benchmark.realtime {
        # status = scanner.tcp_xmas_scan(host_addr, port_nr)
      }
    elsif scann_type == 'null'
      scann_time = Benchmark.realtime {
        # status = scanner.tcp_null_scan(host_addr, port_nr)
      }
    elsif scann_type == 'icmp'
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

    # if status != "down"
    #   service = services()
    # end

    Host.new(:scan_id => @hosts.count,:IP => host_addr, :port => port_nr, :status => status, :scann_type => scann_type, :scann_time => scann_time.round(5).to_s, :service => "blabla")

  end

  def ping(host)
    check = Net::Ping::External.new(host)
    check.ping?
  end

  def services()
    # todo more telnet for udp
    teln = Telnet.new
    return teln.connect(host_addr, port_nr)
  end

  def create
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
