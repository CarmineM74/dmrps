class ClientsController < ApplicationController
  respond_to :json
  before_filter :find_client, :only => [:update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, :with => :client_not_found

  def index
    @clients = Client.all
    respond_with(@clients)
  end

  def create
    @client = Client.create(params[:client])
    respond_with(@client)
  end

  def update
    @client.update_attributes(params[:client])
    respond_with(@client)
  end

  def destroy
    @client.destroy
    respond_with(@client)
  end

private
  
  def find_client
    @client = Client.find(params[:id])
  end

  def client_not_found
    respond_with({error_msg: 'cannot find specified client'}, status: 404, location: nil)
  end

end
