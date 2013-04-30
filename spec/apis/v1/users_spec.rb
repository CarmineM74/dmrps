require 'spec_helper'

describe "/api/v1/users.json", :type => :api do
  let(:url) { "/api/v1/users" }

  describe 'Users list' do
    include_examples "authentication required"

    def do_verb
      get url+".json"
    end

    it 'fetches all the users from the database' do
      do_verb
      users = JSON.parse(User.all.to_json(:only => [:id, :email, :role]))
      JSON.parse(last_response.body).should eql(users)
    end

    it 'replies with status == :ok (200)' do
      do_verb
      last_response.status.should eql(200)
    end
  end

  describe 'Creating a new user' do
    include_examples "authentication required"
    let (:user_attrs) { FactoryGirl.attributes_for(:user, role: 'client') }

    def do_verb
      post url+".json", :user => user_attrs
    end

    context 'with valid parametrs' do
      it 'creates an user' do
        expect {
          do_verb
        }.to change(User,:count).by(1)
      end

      it 'replies with status :created (201)' do
        do_verb
        last_response.status.should eq(201)
      end

      it "replies with user's details" do
        do_verb
        body = JSON.parse(last_response.body)
        body['id'].should_not be_nil
        body['email'].should eql(user_attrs[:email])
      end

    end

    context 'with invalid parameters' do
      it "doesn't create a new user" do
        user_attrs[:email] = ''
        lambda {
          do_verb
        }.should_not change(User,:count)
      end

      it 'replies with status == :unprocessable_entity (422)' do
        user_attrs[:email] = ''
        do_verb
        last_response.status.should eq(422)
      end

      it 'response body contains the list of errors and an error_msg' do
        user_attrs[:email] = ''
        do_verb
        response = JSON.parse(last_response.body)
        response['errors'].should_not be_empty
        response['error_msg'].should eql("Errore durante la creazione dell'utente!")
      end

    end
  end

  describe 'Updating an user' do
    include_examples "authentication required"
    let(:user) { FactoryGirl.create(:user) }

    def do_verb
      put "#{url}/#{user.id}.json", :user => user.attributes.except('id','created_at','updated_at','password_digest').merge({password: user.password,password_confirmation: user.password_confirmation})
    end
    
    context 'with valid parameters' do 
      before(:each) do
        user.password = 'c'
        user.password_confirmation = 'c'
      end

      it 'replies with status == :ok (200)' do
        user.email = 'updated@me.com'
        do_verb
        last_response.status.should eq(200)
      end

      it "updates user's details" do
        user.email = 'updated@me.com'
        do_verb
        user.reload
        user.email.should eq('updated@me.com')        
      end
    end

    context 'with invalid parameters' do
      context "replies with status == :unprocessable_entity (422)" do
        after(:each) do
          last_response.status.should eq(422)
        end

        it "when email is empty" do
          user.email = ''
          do_verb
        end

        it "when email is already taken" do
          user2 = FactoryGirl.create(:user, email: 'iamme@me.com')
          user.email = user2.email
          do_verb
        end

        it "when password is empty" do
          user.password = ''
          do_verb
        end

        it "doesn't update user's details" do
          user.email = ''
          do_verb
          user.reload
          user.email.should_not eql('')
        end
      end

      context "When user doesn't exists" do
        it "replies with status == :not_found (404)" do
          user.id = 200
          do_verb
          last_response.status.should eq(404)
          response = JSON.parse(last_response.body)
        end
      end

      it 'response body contains errors' do
        user.email = ''
        do_verb
        response = JSON.parse(last_response.body)
        response['errors'].should_not be_empty
      end
    end
  end

  describe "Deleting an user" do
    include_examples "authentication required"
    let!(:user) { FactoryGirl.create(:user) }

    let(:url) { "/api/v1/users/#{user.id}.json" }

    def do_verb
      delete url
    end

    context "When user exists" do
      it "removes user from database" do
        expect {
          do_verb
        }.to change(User,:count).by(-1)
        expect {
          User.find(user.id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "replies with status == :no_content (204)" do
        do_verb
        last_response.status.should eql(204)
      end

      context "with interventions" do
        before(:each) do
          i = FactoryGirl.create(:intervention_with_associations, user: user)
        end
        
        it "replies with status == :not_acceptable (406)" do
          do_verb
          last_response.status.should eq(406)
        end

        it "error_msg == Ci sono degli RPS associati all'utente" do
          do_verb
          body = JSON.parse(last_response.body)
          body['error_msg'].should eq("Ci sono degli RPS associati all'utente")
        end

      end

    end

    context "When user doesn't exists" do
        it "replies with status == :not_found (404)" do
          user.id = 200
          do_verb
          last_response.status.should eq(404)
          response = JSON.parse(last_response.body)
        end
    end

  end

end
