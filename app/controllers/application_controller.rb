class ApplicationController < ActionController::Base
  respond_to :json
  layout nil
  protect_from_forgery
  before_filter :intercept_html_requests
  rescue_from ActiveRecord::RecordNotFound, :with => :resource_not_found

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authentication_required
    Rails.logger.info("CURRENT USER: #{current_user.nil? ? 'NON IDENTIFICATO' : current_user.email}")
    Rails.logger.info("SESSION ID: #{session[:user_id]}")
    if current_user.nil?
      render :json => {:error_msg => 'authentication required'}, status: 401
    end
  end

private

  def intercept_html_requests
    render('layouts/dynamic') if request.format == Mime::HTML
  end

protected
  
  def self.responder
    RablResponder
  end

   def resource_not_found
     render 'api/v1/errors/not_found', status: 404
   end

end
