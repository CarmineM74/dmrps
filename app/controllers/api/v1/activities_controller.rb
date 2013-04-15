class Api::V1::ActivitiesController < Api::V1::RestrictedController

  authorize_resource
  before_filter :find_activity, only: [:update, :destroy]

  def index
    @activities = Activity.all
    respond_with(@activities)
  end

  def create
    @activity = Activity.create(params[:activity])
    respond_with(@activity)
  end

  def update
    @activity.update_attributes(params[:activity])
    respond_with(@activity)
  end

  def destroy
    @ativity.destroy
    respond_with({})
  end

private

  def find_activity
    @activity = Activity.find(params[:id])
  end

end
