class Api::V1::ClientsController < Api::V1::RestrictedController

  authorize_resource

  before_filter :find_client, :only => [:update, :destroy]

  def index
    if params[:query].nil? or params[:query].empty?
      @clients = Client.all
    else
      @clients = Client.where("(ragione_sociale like :ragione_sociale) or (id like :codice_cliente)",:ragione_sociale => "%#{params[:query]}%", :codice_cliente => "%#{params[:query]}%")
    end
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
