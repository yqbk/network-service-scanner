require_relative '../../app/controllers/network/scanner'
require_relative '../../app/controllers/network/simple_scann'
require_relative '../../app/controllers/network/scanner_utils'

require 'net/ping'
require 'socket'

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
#   todo problemy w projekcie - dobranie parametrów / kompromis miedzy wydajnoscia a skutecznoscai
#   todo wątki

  #todo ack nie wypisuje


  @syn_scanner
  @ack_scanner
  @fin_scanner
  @udp_scanner
  @teln

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
    elsif name == 'ack'
      return ACK_scanner.new(src, timeout_value, tries, sleep_time)
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
      if @syn_scanner == nil
        @syn_scanner = initScanner('syn')
      end
      @syn_scanner.set_dst_host(host_addr)
      @syn_scanner.set_dst_port(port_nr)
      scann_time = Benchmark.realtime{
        status = @syn_scanner.scann
      }
    elsif scann_type == 'fin'
      if @fin_scanner == nil
        @fin_scanner = initScanner('fin')
      end
      @fin_scanner.set_dst_host(host_addr)
      @fin_scanner.set_dst_port(port_nr)
      scann_time = Benchmark.realtime {
        status = @fin_scanner.scann
      }
    elsif scann_type == 'udp'
      if @udp_scanner == nil
        @udp_scanner = initScanner('udp')
      end
      @udp_scanner.set_dst_host(host_addr)
      @udp_scanner.set_dst_port(port_nr)
      scann_time = Benchmark.realtime {
        status = @udp_scanner.scann
      }
    elsif scann_type == 'ack'
      if @ack_scanner == nil
        @ack_scanner = initScanner('ack')
      end
      @ack_scanner.set_dst_host(host_addr)
      @ack_scanner.set_dst_port(port_nr)
      scann_time = Benchmark.realtime {
        status = @ack_scanner.scann
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
    elsif scann_type == 'clear'
      Host.delete_all
    else
      # begin
      #   redirect_to hosts_url, alert: 'incorrect type'
      #   return
    end

    # if status != "down"
    # if @teln = nil
    #   @teln = ScannerUtils.new
    # end
    #   service = @teln.connect(host_addr, port_nr)
    # end

    if scann_type == 'simple'
      scann_time = Benchmark.realtime {

        #  puts "dziala"
        #   todo save hosts to database
        #
        # ip_address = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address

        # puts "\n\n\n HERE \n"
        # puts ip_address
        # puts "\nTUTAJ\n\n\n"

        fast_scanner = SimpleScann.new
        hosts = fast_scanner.performFastScann()
      }
    else
      hosts = Host.new(:scan_id => @hosts.count, :IP => host_addr, :port => port_nr, :status => status, :scann_type => scann_type, :scann_time => scann_time.round(5).to_s, :service => "lalal")
    end

    puts "lalal"

    hosts

  end



  def ping(host)
    check = Net::Ping::External.new(host)
    if !check.ping?

      @ack_scanner.set_dst_host(host)
      @ack_scanner.set_dst_port(80)

      status = @ack_scanner.scann

      if status != "filtered"
        return true
      else
        return false
      end

    else
      return true
    end

  end

  def create
    @hosts = Host.all


    # init scanners if not initialized yet



    begin
      @host = scann()
      @host.save
      # Host.delete_all
    rescue NoMethodError
      nil
    end

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
