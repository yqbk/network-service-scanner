# require Scanner

class HostsController < ApplicationController

  def index
    @hosts = Host.all
  end

  def destroy
    @host = Host.find(params[:id])
    @host.destroy
    head :no_content
  end

  def scann()

    Host.delete_all

    scanner = Scanner.new

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
    status = scanner.tcp_syn_scan(host_addr, port_nr)

    Host.new(:IP => host_addr, :port => port_nr, :status => status, :scann_type => 'SYN scann', :scann_time => '1 sekunda')

  end

  def create


    @host = scann()

    @host.save

    render_host()

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
