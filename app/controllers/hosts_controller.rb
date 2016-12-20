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
    response = ''

    begin

      server = Net::Telnet::new('Host' => ip,
                                'Port' => port,
                                'Telnetmode' => false)

      lines_to_send = ['Hello!', 'This is a test', 'quit']

      lines_to_send.each do |line|
        server.puts(line)
      end

        server.waitfor(/./) do |data|
          if data != nil
            response = response + data
          end
        end



      # host = Net::Telnet::new(
      #     "Host"       => ip,  # default: "localhost"
      #     "Port"       => port,           # default: 23
      #     "Binmode"    => false,        # default: false
      #     "Output_log" => "output_log", # default: nil (no output)
      #     "Prompt"     => /[$%#>] \z/n, # default: /[$%#>] \z/n
      #     "Telnetmode" => true,         # default: true
      #     "Timeout"    => 1,           # default: 10
      #     # if ignore timeout then set "Timeout" to false.
      #     "Waittime"   => 0            # default: 0
      # # proxy is Net::ScannerUtils or IO object
      # )
      #
      # response = host.cmd('')

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

    puts  response

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

    if name == 'syn' and @syn_scanner == nil
      return SYN_scanner.new(src, timeout_value, tries, sleep_time)
    elsif name == 'ack' and @ack_scanner == nil
      return ACK_scanner.new(src, timeout_value, tries, sleep_time)
    elsif name == 'fin' and @fin_scanner == nil
      return FIN_scanner.new(src, timeout_value, tries, sleep_time)
    elsif name == 'udp' and @udp_scanner == nil

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

    if status == "up"
      service = telnet(host_addr, port_nr)
    else
      service = "-"
    end

    Host.new(:scan_id => @hosts.count,:IP => host_addr, :port => port_nr, :status => status, :scann_type => scann_type, :scann_time => scann_time.round(5).to_s, :service => service)

  end


  def create
    @hosts = Host.all
    scann_type = params[:host][:scann_type]

    begin
      @host = scann(scann_type)
      @host.save
      # Host.delete_all
    rescue NoMethodError
      nil
    end
  render_host()

  # Host.delete_all
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
