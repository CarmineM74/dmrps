require 'spec_helper'

describe "/api/v1/users.json", :type => :api do
  let(:url) { "/api/v1/users" }

  describe 'Users list' do
    it 'fetches all the users from the database' do
      get url+".json"
      users = JSON.parse(User.all.to_json(:only => [:id, :email]))
      JSON.parse(last_response.body).should eql(users)
    end

    it 'replies with status == :ok (200)' do
      get url+".json"
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

      it "replies with user's details" do
        do_post
        body = JSON.parse(last_response.body)
        body['id'].should_not be_nil
        body['email'].should eql(@user.email)
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

      it 'response body contains the list of errors and an error_msg' do
        @user.email = ''
        do_post
        response = JSON.parse(last_response.body)
        response['errors'].should_not be_empty
        response['error_msg'].should eql("Errore durante la creazione dell'utente!")
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

    context 'with invalid parameters' do
      context "replies with status == :unprocessable_entity (422)" do
        after(:each) do
          last_response.status.should eq(422)
        end

        it "when email is empty" do
          @user.email = ''
          do_update
        end

        it "when email is already taken" do
          user2 = FactoryGirl.create(:user, email: 'iamme@me.com')
          @user.email = user2.email
          do_update
        end

        it "when password is empty" do
          @user.password = ''
          do_update
        end

        it "doesn't update user's details" do
          @user.email = ''
          do_update
          @user.reload
          @user.email.should_not eql('')
        end
      end

      context "When user doesn't exists" do
        it "replies with status == :not_found (404)" do
          @user.id = 200
          do_update
          last_response.status.should eq(404)
          response = JSON.parse(last_response.body)
        end
      end

      it 'response body contains errors' do
        @user.email = ''
        do_update
        response = JSON.parse(last_response.body)
        response['errors'].should_not be_empty
      end
    end
  end

  describe "Deleting an user" do
    before(:each) { @user = FactoryGirl.create(:user) }
    let(:url) { "/api/v1/users/#{@user.id}.json" }

    def do_delete
      delete url
    end

    context "When user exists" do
      it "removes user from database" do
        expect {
          do_delete
        }.to change(User,:count).by(-1)
        expect {
          User.find(@user.id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "replies with status == :no_content (204)" do
        do_delete
        last_response.status.should eql(204)
      end
    end

    context "When user doesn't exists" do
        it "replies with status == :not_found (404)" do
          @user.id = 200
          do_delete
          last_response.status.should eq(404)
          response = JSON.parse(last_response.body)
        end
    end

  end

end
