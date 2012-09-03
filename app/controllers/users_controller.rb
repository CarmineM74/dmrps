class UsersController < ApplicationController
  respond_to :json

  #before_filter :authentication_required
  #before_filter :administrator_required

  before_filter :find_user, :only => [:update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, :with => :user_not_found

  def index
    @users = User.all
  end

  def create
    @user = User.create(params[:user])
    respond_with(@user) 
  end

  def update
     @user.update_attributes(params[:user])
     respond_with(@user)
  end

  def destroy
    @user.destroy
    respond_with(@user)
  end

private

  def find_user
    @user = User.try(:find,params[:id])
  end

  def user_not_found
    respond_with({error_msg: 'cannot find specified user'}, status: 404, location: nil)
  end

end
