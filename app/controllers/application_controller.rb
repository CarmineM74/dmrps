class ApplicationController < ActionController::Base
  layout nil
  protect_from_forgery
  before_filter :intercept_html_requests

private

  def intercept_html_requests
    render('layouts/dynamic') if request.format == Mime::HTML
  end

end
