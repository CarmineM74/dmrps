class Api::V1::LocationsController < ApplicationController
  before_filter :find_client

  def index
    @locations = @client.locations
    respond_with(@locations)
  end

  def create
#    @location = @client.locations.create(params[:location])
    #@location = Location.new(params[:location])
    #@location.client = @client
    #@location.save
    respond_with({})
  end

  def update
    @location = @client.locations.find(params[:id])
    @location.update_attributes(params[:location])
    respond_with(@location)
  end

  def destroy
    @location = @client.locations.find(params[:id])
    @client.locations.delete(@location)
    respond_with({})
  end

protected
  
  def find_client
    @client = Client.find(params[:client_id])
  end

end
