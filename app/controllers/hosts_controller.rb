require 'scanner'

class HostsController < ApplicationController

  # todo udp scann
  # todo OS detection
  # todo Implement full scann of the network with multiple methods , nmap -sP
  # todo Navbar in the top of page
  # todo refresh chartkick on change or add generate chart button
  # todo hosts map with d3.js
  # todo refactor scanner to implement inheritance

#   <%= javascript_include_tag "https://www.gstatic.com/charts/loader.js" %>
#   <%= line_chart @hosts.group(:scan_id).minimum(:scann_time) %>


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

    # scanner = Scanner.new
    teln = Telnet.new

    # test = params[:host][:IP]

    # [6,13,14,18].each do |ip|
    #   host_addr = params[:host][:IP] + ip.to_s
    #   puts(host_addr)
    #   status = scanner.icmp_scan(host_addr)
    #   @host = Host.new(:IP => host_addr, :status => status)
    #   @host.save
    # end

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
        # src = 1998
        # timeout_value = 5
        # tries = 10
        # sleep_time = 0
        #
        # scanner = ICMP_scanner.new(host_addr, port_nr, src, timeout_value, tries, sleep_time)
        # status = scanner.scann
      }
    elsif scann_type == 'clear'
      Host.delete_all
    else
      begin
        redirect_to hosts_url, alert: 'incorrect type'
        return
      end
    end


    # todo more telnet for udp
    if status == "up" || "filtered"
      service = teln.connect(host_addr, port_nr)
    end

    Host.new(:scan_id => @hosts.count,:IP => host_addr, :port => port_nr, :status => status, :scann_type => scann_type, :scann_time => scann_time.round(5).to_s, :service => service)

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
    # redirect_to :back

    #
    # [1..100].each do |ip|
    #   status = scanner.icmp_scan(:address + ip)
    #   unless status
    #     @host = Host.new(:ip => (:address + ip), :end => Time.now)
    #   end
    # end
    #
    # status = scanner.icmp_scan(params[:host][:IP])
    #
    #
    # @host = Host.new(:IP => params[:host][:IP], :status => status)
    # @page= Page.new(params[:page].merge(:user_id => 1, :foo => "bar"))

    # if @host.save
    #   render json: @host
    # else
    #   render json: @host.errors, status: :unprocessable_entity
    # end
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
