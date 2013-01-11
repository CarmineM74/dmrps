module ApiHelper
  include Rack::Test::Methods
  def app
    Rails.application
  end

  def login_as(user)
    puts "Logging in as #{user.email} ..."
    ApplicationController.any_instance.stub(:current_user).and_return(user)
  end

  def logout
    puts "Logging out ..."
    ApplicationController.any_instance.stub(:current_user).and_return(nil)
  end

end

RSpec.configure do |config|
  config.include ApiHelper, :type => :api
end
