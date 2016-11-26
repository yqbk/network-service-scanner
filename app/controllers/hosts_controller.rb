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

  def create

    scanner = Scanner.new

    Host.delete_all

    # test = params[:host][:IP]

    (1..20).each do |ip|
      host_addr = params[:host][:IP] + ip.to_s
      puts(host_addr)
      status = scanner.icmp_scan(host_addr)
      @host = Host.new(:IP => host_addr, :status => status)
      @host.save

    end

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
    params.require(:host).permit(:IP)
  end

  def render_host
    if @host.save
      render json: @host
    else
      render json: @host.errors, status: :unprocessable_entity
    end

  end
end
