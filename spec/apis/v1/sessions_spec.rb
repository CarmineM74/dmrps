require 'spec_helper'

describe "/api/v1/sessions.json", :type => :api do
  let(:url) { "/api/v1/sessions" }

  describe 'Login' do
    it "replies with status == :ok (200) when credentials are valid"
    it "replies with status == :authentication_required (401) when credentials are not valid"
  end

  describe 'Logout' do
    it "replies with status == :ok (200) when successful"
    it "replies with status == :unauthorized_request (406) when trying to logout a different user"
  end

end
