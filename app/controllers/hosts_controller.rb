require_relative '../../app/controllers/network/scanner'
require_relative '../../app/controllers/network/simple_scann'
require_relative '../../app/controllers/network/scanner_utils'

require 'net/ping'
require 'socket'
require 'net/telnet'

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

  def telnet(ip, port)

    service = '?'

    begin
      host = Net::Telnet::new(
          "Host"       => ip,  # default: "localhost"
          "Port"       => port,           # default: 23
          "Binmode"    => false,        # default: false
          "Output_log" => "output_log", # default: nil (no output)
          "Prompt"     => /[$%#>] \z/n, # default: /[$%#>] \z/n
          "Telnetmode" => true,         # default: true
          "Timeout"    => 1,           # default: 10
          # if ignore timeout then set "Timeout" to false.
          "Waittime"   => 0            # default: 0
      # proxy is Net::ScannerUtils or IO object
      )

      response = host.cmd('')

    rescue Net::ReadTimeout, Errno::ECONNREFUSED, Net::OpenTimeout
      service = '-'
    end


    if response == nil
      puts "\n\nresponse is nil\n\n"
    elsif response.downcase.include? 'ssh'
      service = 'SSH'
    elsif response.downcase.include? 'http'
      service = 'http'
    elsif response.downcase.include? 'ftp'
      service = 'FTP'
    elsif response.downcase.include? 'SMTP'
      service = 'Mail server'
    end

    puts "\n\n---response--- " + response + " ------\n\n"

    service

  end


  def ping_host(host)
    check = Net::Ping::External.new(host)
    if !check.ping?

      if @ack_scanner == nil
        @ack_scanner = initScanner('ack')
      end

      @ack_scanner.set_dst_host(host)
      @ack_scanner.set_dst_port(80)

      status = @ack_scanner.scann

      if status != "filtered"
        true
      else
        false
      end

    else
      true
    end
  end

  def initScanner(name)

    src = 1998 #change here
    timeout_value = 1
    tries = 20
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

  def scann(scann_type)

    host_addr = params[:host][:IP]
    port_nr = params[:host][:port].to_i
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

        if ping_host(host_addr)
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

    if scann_type == 'getActiveHosts'
      puts "\n\n\n getActiveHosts"
      simple_scann()
      puts " getActiveHosts finished\n\n\n"
    else
      @host = Host.new(:scan_id => @hosts.count, :IP => host_addr, :port => port_nr, :status => status, :scann_type => scann_type, :scann_time => scann_time.round(5).to_s, :service => "lalal")
      save_host
      render_host()
    end

    puts "lalal"

  end

  # --------------------------------------------------------------------------------------------------------------------

  # def checkIfFiltered (ip, port)
  #
  #   # src = 1998
  #   # timeout_value = 5
  #   # tries = 10
  #   # sleep_time = 0
  #   #
  #   # @ack_scanner.set_dst_host(ip)
  #   # @ack_scanner.set_dst_port(port)
  #   # status = @ack_scanner.scann
  #   #
  #   # return status == 'unfiltered'
  #
  #   true
  #
  # end
  #
  # def checkIfUpForTCP (ip, port)
  #
  #   src = 1998
  #   timeout_value = 5
  #   tries = 10
  #   sleep_time = 0
  #
  #
  #
  #   scanner = FIN_scanner.new(src, timeout_value, tries, sleep_time)
  #   scanner.set_dst_host(ip)
  #   scanner.set_dst_port(port)
  #   status_fin = scanner.scann
  #
  #   scanner2 = SYN_scanner.new( src, timeout_value, tries, sleep_time)
  #   scanner2.set_dst_host(ip)
  #   scanner2.set_dst_port(port)
  #   status_syn = scanner2.scann
  #
  #   return status_fin == 'up' || status_syn =='up'
  #
  # end
  #
  # def checkIfUpForUDP (ip, port)
  #
  #   dst = 53
  #   src = 1998
  #   timeout_value = 22
  #   tries = 4
  #   sleep_time = 5
  #
  #   scanner = UDP_scanner.new( src, timeout_value, tries, sleep_time)
  #   scanner.set_dst_host(ip)
  #   scanner.set_dst_port(port)
  #
  #   # host_addr, dst,
  #
  #   status = scanner.scann
  #
  #   return status == 'up'
  #
  # end
  #
  # def scannTCP(ip, port)
  #
  #   if ping_host(ip)
  #     if checkIfFiltered(ip,port)
  #       if checkIfUpForTCP(ip,port)
  #         puts "  host #{ip}, port #{port} -> up"
  #         true
  #       else
  #         puts "    host #{ip}, port #{port} -> down"
  #       end
  #     end
  #   else
  #
  #     false
  #   end
  #
  # end
  #
  # def scannUDP(ip, port)
  #
  #   if checkIfUpForUDP(ip,port)
  #     true
  #   end
  #
  # end
  #
  #
  #
  # def perform_simple_scann(ip)
  #
  #   puts "in perform_simple_scann"
  #
  #   if ping_host(ip)
  #     @tcp_ports.each do |port|
  #       if scannTCP(ip, port)
  #         # @host = Host.new(:scan_id => @hosts.count, :IP => host_addr, :port => port_nr, :status => status, :scann_type => scann_type, :scann_time => scann_time.round(5).to_s, :service => "lalal")
  #         puts "blabla"
  #         @host = Host.new(:scan_id => @hosts.count, :IP => ip, :port => port, :status => 'up', :scann_type => 'tcp', :scann_time => 1, :service => " ")
  #         save_host
  #         # todo render host on each success
  #         # @hosts.push(Host.new(:scan_id => '1', :IP => ip, :port => port, :status => 'up', :scann_type => 'tcp', :scann_time => 1, :service => " "))
  #         # @open_tcp_ports.push(port)
  #       end
  #     end
  #
  #     # @udp_ports.each do |port|
  #     #   if scannUDP(ip, port)
  #     #     # @open_udp_ports.push(port)
  #     #     @hosts.push(Host.new(:scan_id => '1', :IP => ip, :port => port, :status => 'up', :scann_type => 'udp', :scann_time => 1, :service => " "))
  #     #   end
  #     # end
  #   end
  # end
  #
  #
  # # --------------------------------------------------------------------------------------------------------------------
  #
  #
  # def simple_scann()
  #
  #   puts "test 1"
  #   @config = PacketFu::Utils.whoami?()
  #
  #   @tcp_ports = [21,22,23,24,25,53,80,443,1723,3389,4567,8080]
  #   @udp_ports = [53,111,123,137,161]
  #
  #   @tcp_ports
  #   @udp_ports
  #   @open_tcp_ports = []
  #   @open_udp_ports = []
  #   @hosts = []
  #
  #
  #   ip = @config[:ip_saddr].split(".")
  #   network = ip[0] + '.' + ip[1] + '.' + ip[2] + '.'
  #
  #   (1..255).each do |host|
  #     @hosts.append(network + host.to_s)
  #     puts "\n host: #{network + host.to_s}"
  #     # perform_simple_scann(network + host.to_s)
  #     # puts "\n\n finished host"
  #   end
  #
  #   puts "#{@hosts.length}"
  #
  #   render json: @hosts
  #
  #
  #
  #              # perform_simple_scann("192.168.0.54")
  #
  #   # render_host()
  # end





  # def ping(host)
  #   check = Net::Ping::External.new(host)
  #   if !check.ping?
  #
  #     @ack_scanner.set_dst_host(host)
  #     @ack_scanner.set_dst_port(80)
  #
  #     status = @ack_scanner.scann
  #
  #     if status != "filtered"
  #       return true
  #     else
  #       return false
  #     end
  #
  #   else
  #     return true
  #   end
  #
  # end

  def create
    @hosts = Host.all
    scann_type = params[:host][:scann_type]

    begin
      if scann_type == 'simple'
        simple_scann()
      else
        scann(scann_type)
      end
      # Host.delete_all
    rescue NoMethodError
      nil
    end
  end

  private

  def save_host()
    @host.save
  end

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
