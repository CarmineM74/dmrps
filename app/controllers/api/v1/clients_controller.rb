class Api::V1::ClientsController < ApplicationController
  before_filter :find_client, :only => [:update, :destroy]

  def index
    @clients = Client.all
    respond_with(@clients)
  end

  def show
    @client = Client.find(params[:id])
    respond_with(@client)
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
    respond_with({})
  end

private
  
  def find_client
    @client = Client.find(params[:id])
  end

end
