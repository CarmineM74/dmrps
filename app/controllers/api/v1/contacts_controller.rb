class Api::V1::ContactsController < Api::V1::RestrictedController

  authorize_resource
  before_filter :find_client
  before_filter :find_contact, only: [:update, :destroy]

  def index
    @contacts = @client.contacts
    respond_with(@contacts)
  end

  def create
    @contact = @client.contacts.create(params[:contact])
    respond_with(@contact)
  end

  def update
    @contact.update_attributes(params[:contact])
    respond_with(@contact)
  end

  def destroy
    if @client.interventions.find_by_contatto_and_email(@contact.name,@contact.email)
      render :json => {error_msg: "Il contatto e' stato assegnato ad almeno un RPS"}, status: 406
    else
      @client.contacts.delete(@contact) 
      respond_with({})
    end
  end

private

  def find_contact
    @contact = @client.contacts.find(params[:id])
  end

  def find_client
    @client = Client.find(params[:client_id])
  end

end
