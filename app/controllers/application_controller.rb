class ApplicationController < ActionController::Base
  respond_to :json
  layout nil
  protect_from_forgery
  before_filter :intercept_html_requests
  rescue_from ActiveRecord::RecordNotFound, :with => :resource_not_found

private

  def intercept_html_requests
    render('layouts/dynamic') if request.format == Mime::HTML
  end

protected
  
  def self.responder
    RablResponder
  end

   def resource_not_found
     respond_with({error_msg: 'cannot find requested resource'}, status: 404, location: nil)
   end

end
