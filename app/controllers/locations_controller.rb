class LocationsController < ApplicationController
  respond_to :json
  before_filter :find_client
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
    @locations = @client.locations
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
    @client = Client.find(params[:client_id])
  end

  def record_not_found(error)
    respond_with({error_msg: 'resource not found'}, status: 404, location: nil)
  end

end
