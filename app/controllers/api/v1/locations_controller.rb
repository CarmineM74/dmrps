class Api::V1::LocationsController < Api::V1::RestrictedController

  authorize_resource

  before_filter :find_client, except: [:show]

  def index
    @locations = @client.locations
    respond_with(@locations)
  end

  def show
    @location = Location.find(params[:id])
    respond_with(@location)
  end

  def create
    render :json => {error_msg: "La creazione delle sedi e' consentita solo agli amministratori!"}, status: 406 and return unless current_user.admin?
    @location = @client.locations.create(params[:location])
    respond_with(@location)
  end

  def update
    render :json => {error_msg: "La modifica delle sedi e' consentita solo agli amministratori!"}, status: 406 and return unless current_user.admin?
    @location = @client.locations.find(params[:id])
    @location.update_attributes(params[:location])
    respond_with(@location)
  end

  def destroy
    render :json => {error_msg: "La rimozione delle sedi e' consentita solo agli amministratori!"}, status: 406 and return unless current_user.admin?
    if Intervention.joins(:locations).where("locations.id == #{params[:id]}").count > 0
      render :json => {error_msg: "La sede e' stata utilizzata in almeno un intervento"}, status: 406
    else
      @location = @client.locations.find(params[:id])
      @client.locations.delete(@location)
      respond_with({})
    end
  end

protected

  def find_client
    @client = Client.find(params[:client_id])
  end

end
