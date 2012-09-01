class UsersController < ApplicationController
  respond_to :json

  #before_filter :authentication_required
  #before_filter :administrator_required

  before_filter :find_user, :only => [:update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, :with => :user_not_found

  def index
    @users = User.all
    respond_with(@users)
  end

  def create
    user = User.new(params[:user])
    if user.save
      respond_with(user)
    else
      error_type = (user.errors.empty? ? 'save' : 'validation')
      respond_with({error_type: error_type, error_msg: 'cannot create user', errors: user.errors}, :status => 400, :location => nil) 
    end
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
    respond_with({error_msg: 'cannot find specified user'}, status: 400, location: nil)
  end

end
