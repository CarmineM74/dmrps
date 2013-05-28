class Api::V1::UsersController < Api::V1::RestrictedController
  authorize_resource

  before_filter :find_user, :only => [:update, :destroy]

  def index
    @users = User.all
  end

  def create
    @user = User.create(params[:user])
    set_perms_and_password()
    respond_with(@user) 
  end

  def update
     @user.update_attributes(params[:user])
    set_perms_and_password()
     respond_with(@user)
  end

  def destroy
    if @user.interventions.size > 0
      render :json => {error_msg: "Ci sono degli RPS associati all'utente"}, status: 406
    else
      @user.destroy
      respond_with(@user)
    end
  end

private

  def set_perms_and_password
    if params[:password]
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
    end
  end

  def find_user
    @user = User.find(params[:id])
  end

end
