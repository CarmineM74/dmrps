class Api::V1::InterventionsController < ApplicationController

  def index
    @interventions = Intervention.all
    respond_with(@interventions)
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
  end

protected
  
  def find_client
    @client = Client.find(params[:client_id])
  end

end
