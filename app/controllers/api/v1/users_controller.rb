class Api::V1::UsersController < Api::V1::RestrictedController

  authorize_resource

  before_filter :find_user, :only => [:update, :destroy]

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
    @user = User.find(params[:id])
  end

end
