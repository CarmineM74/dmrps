class Api::V1::UsersController < Api::V1::RestrictedController
  authorize_resource

  before_filter :find_user, :only => [:update, :destroy]

  def index
    @users = User.all
  end

  def create
    render :json => {error_msg: "La creazione di nuovi utenti e' consentita solo agli amministratori!"}, status: 406 and return unless current_user.admin?
    @user = User.new(params[:user])
    if @user.user?
      @user.permissions << Permission.find_by_rule('ManageActivities')
      @user.permissions << Permission.find_by_rule('CreateInterventions')
    end
    set_perms_and_password()
    respond_with(@user)
  end

  def update
    @user.update_attributes(params[:user].except('password','password_confirmation'))
    set_perms_and_password()
    respond_with(@user)
  end

  def destroy
    if @user.interventions.size > 0
      render :json => {error_msg: "Ci sono degli RPS associati all'utente"}, status: 406
    else
      render :json => {error_msg: "Solo l'amministratore puo' rimuovere gli utenti dal sistema!"}, status: 406 and return unless current_user.admin?
      render :json => {error_msg: "Non e' possibile rimuovere l'unico amministratore del sistema!"}, status: 406 and return if (@user.admin? and (User.where(role: 'admin').count == 1))
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
    @user.save
  end

  def find_user
    @user = User.find(params[:id])
  end

end
