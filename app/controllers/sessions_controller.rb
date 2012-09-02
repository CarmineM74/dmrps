class SessionsController < ApplicationController
  respond_to :json

  def create
    u = User.find_by_email(params[:email])
    @user = u && u.authenticate(params[:password])
    if @user
      session[:user_id] = @user.id
    end
    @status = @user ? :ok : :unauthorized
    respond_with(@user, :responder => RablResponder, :status => @status)
  end

  def destroy
    session[:user_id] = nil
    respond_with(true, :responder => RablResponder)
  end

end
