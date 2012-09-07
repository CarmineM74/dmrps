class LocationsController < ApplicationController
  before_filter :find_client

  def index
    @locations = @client.locations
    respond_with(@locations)
  end

  def create
    @location = @client.locations.create(params[:location])
    respond_with(@location)
  end

  def update
    @location = @client.locations.find(params[:id])
    @location.update_attributes(params[:location])
    respond_with(@location)
  end

  def destroy
    @location = @client.locations.find(params[:id])
    @client.locations.delete(@location)
    respond_with(@location)
  end

protected
  
  def find_client
    logger.info("Current client id: #{params[:client_id]}")
    @client = Client.find(params[:client_id])
  end

end
