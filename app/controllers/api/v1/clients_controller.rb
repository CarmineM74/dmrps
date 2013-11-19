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
    render :json => {error_msg: "La creazione dei clienti e' consentita solo agli amministratori!"}, status: 406 and return unless current_user.admin?
    @client = Client.create(params[:client])
    respond_with(@client)
  end

  def update
    render :json => {error_msg: "La modifica dei clienti e' consentita solo agli amministratori!"}, status: 406 and return unless current_user.admin?
    @client.update_attributes(params[:client])
    respond_with(@client)
  end

  def destroy
    render :json => {error_msg: "L'eliminazione dei clienti e' consentita solo agli amministratori!"}, status: 406 and return unless current_user.admin?
    Rails.logger.info "Client interventions COUNT: #{@client.interventions.count}"
    if @client.interventions.count > 0
      render :json => {error_msg: 'Ci sono degli RPS associati al cliente'}, status: 406
    else
      @client.destroy
      respond_with({})
    end
  end

private

  def find_client
    @client = Client.find(params[:id])
  end

end
