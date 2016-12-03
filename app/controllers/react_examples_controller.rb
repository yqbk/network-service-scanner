class ReactExamplesController < ApplicationController
  def component
    @hosts = Host.all
  end

  def index
    @hosts = Host.all
  end
end
