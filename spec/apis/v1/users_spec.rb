require 'spec_helper'

describe "/api/v1/users.json", :type => :api do

  let(:url) { "/api/v1/users.json" }

  describe 'GET index' do
    it 'fetches all the users from the database' do
      @user = FactoryGirl.create(:user)
      get url
      users = JSON.parse(User.all.to_json(:only => [:id, :email]))
      JSON.parse(last_response.body).should eql(users)
      last_response.status.should eql(200)
    end
  end

end
