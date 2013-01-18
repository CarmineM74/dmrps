module ApiHelper
  include Rack::Test::Methods
  def app
    Rails.application
  end

  def login_as(user)
    Api::V1::RestrictedController.any_instance.stub(:current_user).and_return(user)
  end

  def logout
    Api::V1::RestrictedController.any_instance.stub(:current_user).and_return(nil)
  end

  shared_examples "authentication required" do
    it "when not logged in replies with status == 401 (unauthorized)" do
      logout
      do_verb
      last_response.status.should eq(401)
    end

    it "when logged in replies with status != 401" do
      login_as(FactoryGirl.create(:user))
      do_verb
      last_response.status.should_not eq(401)
    end

    before(:each) { login_as(FactoryGirl.create(:user)) }
  end

end

RSpec.configure do |config|
  config.include ApiHelper, :type => :api
end
