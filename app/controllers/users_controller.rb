class UsersController < ApplicationController
  respond_to :json
  #before_filter :authentication_required
  before_filter :find_user, :only => [:update, :destroy]

  def index
    @users.all
    respond_with(@users)
  end

  def create
    user = User.new(params[:user])
    if user.save
      respond_with(user)
    else
      respond_with({error_msg: 'cannot create user', errors: user.errors}, status: 400, location: nil) 
    end
  end

  def update
    @user = User.update_attributes(params[:user])
    respond_with(@user)
  end

  def destroy
    @user.destroy
    respond_with(@user)
  end

private
  def find_user
    @user = User.try(:find,params[:id])
    respond_with({error_msg: 'cannot find specified user'}, status: 400, location: nil)
  end
end
