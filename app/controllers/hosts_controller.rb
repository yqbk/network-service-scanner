class HostsController < ApplicationController

  def index
    @hosts = Host.all
  end

  def create
    @host = Host.new(host_params)

    if @host.save
      render json: @host
    else
      render json: @host.errors, status: :unprocessable_entity
    end
  end

end
