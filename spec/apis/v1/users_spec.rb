require 'spec_helper'

describe "/api/v1/users.json", :type => :api do
  let(:url) { "/api/v1/users" }

  describe 'Users list' do
    it 'fetches all the users from the database' do
      get url+".json"
      users = JSON.parse(User.all.to_json(:only => [:id, :email]))
      JSON.parse(last_response.body).should eql(users)
      last_response.status.should eql(200)
    end
  end

  describe 'Creating a new user' do
    before(:each) do
      @user = FactoryGirl.build(:user)
    end
    
    def do_post
      params = {email: @user.email, password: @user.password, password_confirmation: @user.password_confirmation}
      post url+".json", :user => params
    end

    context 'with valid parametrs' do
      it 'creates an user' do
        expect {
          do_post
        }.to change(User,:count).by(1)
      end

      it 'replies with status :created (201)' do
        users = User.all.to_json
        do_post
        last_response.status.should eq(201)
      end
    end

    context 'with invalid parameters' do
      it "doesn't create a new user" do
        @user.email = ''
        lambda {
          do_post
        }.should_not change(User,:count)
      end

      it 'replies with status == :unprocessable_entity (422)' do
        @user.email = ''
        do_post
        last_response.status.should eq(422)
      end
    end
  end

  describe 'Updating an user' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    
    def do_update
      put "#{url}/#{@user.id}.json", :user => {email: @user.email, password: @user.password, password_confirmation: @user.password_confirmation} 
    end

    context 'with valid parameters' do 
      it 'replies with status == :ok (200)' do
        @user.email = 'updated@me.com'
        do_update
        last_response.status.should eq(200)
      end

      it "updates user's details" do
        @user.email = 'updated@me.com'
        do_update
        @user.reload
        @user.email.should eq('updated@me.com')        
      end

    end
   
  end


end
