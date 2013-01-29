class SessionsController < Api::V1::BaseController
  respond_to :json

  def authenticated_user
    @user = nil
    @user = current_user
    respond_with(@user)
  end

  def create
    u = User.find_by_email(params[:email])
    @user = u && u.authenticate(params[:password])
    if @user
      session[:user_id] = @user.id
    end
    @status = @user ? :ok : :unauthorized
    respond_with(@user, :status => @status)
  end

  def destroy
    if current_user 
      if (current_user.id == params[:id].to_i)
        session[:user_id] = nil
        respond_with(true)
      else
        render :json => {:error_msg => 'unauthorized request'}, status: 406
      end
    end
  end

end
