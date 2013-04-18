class Api::V1::InterventionsController < Api::V1::RestrictedController

  authorize_resource

  after_filter :find_or_create_contact, only: [:create, :update]

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
    current_activities = @intervention.activities.map { |a| a.id }
    new_activities = params[:activities_ids]
    (current_activities - new_activities).each { |id| @intervention.activities.delete(Activity.find(id)) }

    (new_activities - current_activities).each { |id| @intervention.activities << Activity.find(id) }
    respond_with(@intervention)
  end

  def destroy
    @intervention = Intervention.find(params[:id])
    @intervention.delete
    respond_with({})
  end

  def rps
    respond_to do |format|
      format.pdf do
        @intervention = Intervention.find(params[:intervention_id])
        pdf = RpsPdf.new(@intervention)
        send_data pdf.render,filename: "rps.pdf", type: "application/pdf"
      end
    end
  end

protected

  def find_or_create_contact
    @client = @intervention.locations.first.client
    @contact = @client.contacts.find_by_name(params[:contact_name])
    @contact = @client.contacts.create(name: params[:contact_name], email: params[:email]) if @contact.nil?
  end
  
  def find_client
    @client = Client.find(params[:client_id])
  end

end
