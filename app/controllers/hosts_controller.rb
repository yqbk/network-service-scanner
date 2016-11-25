class HostsController < ApplicationController

  def index
    @hosts = Hosts.all
  end

  def create
    @host = Hosts.new(host_params)

    if @host.save
      render json: @host
    else
      render json: @host.errors, status: :unprocessable_entity
    end
  end

end
