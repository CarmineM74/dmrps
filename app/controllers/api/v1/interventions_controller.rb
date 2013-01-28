class Api::V1::InterventionsController < Api::V1::RestrictedController

  def index
    if params[:query].empty?
      @interventions = Intervention.all
    else
      @interventions = Intervention.joins(:user,:locations => :client).where("(interventions.id like :query) or (users.email like :query) or (clients.ragione_sociale like :query)",query: "%#{params[:query]}%")
    end
    respond_with(@interventions)
  end

  def show
    @intervention = Intervention.find(params[:id])
    respond_with(@intervention)
  end

  def create
    @intervention = Intervention.create(params[:intervention])
    respond_with(@intervention)
  end

  def update
    @intervention = Intervention.find(params[:id])
    @intervention.update_attributes(params[:intervention])
    respond_with(@intervention)
  end

  def destroy
    @intervention = Intervention.find(params[:id])
    @intervention.delete
    respond_with({})
  end

protected
  
  def find_client
    @client = Client.find(params[:client_id])
  end

end
