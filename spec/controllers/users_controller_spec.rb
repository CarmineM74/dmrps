require 'spec_helper'

describe UsersController do

  describe 'GET index' do
    it 'fetches all the users from the database' do
      @user = FactoryGirl.create(:user)
      User.should_receive(:all) { [@user] }
      get :index, :format => 'json'
      assigns(:users).should eq([@user])
    end
  end

  describe 'POST create' do
    before(:each) do
      @user = FactoryGirl.build(:user)
    end
 
    def do_post
      post :create, :user => {email: @user.email, password: @user.password, password_confirmation: @user.password_confirmation}, :format => 'json'
    end

    context 'with valid parameters' do
      it 'creates an user' do
        expect {
          do_post
        }.to change(User,:count).by(1)
      end
      
      it 'replies with the user just created'

    end

    context 'with invalid parameters' do
      it "doesn't create a new user" do
        @user.email = ''
        lambda {
          do_post
        }.should_not change(User,:count)
      end

      it 'replies with an error explaining what prevented user creation'

    end
  end

  describe 'PUT update' do
    context 'with valid parameters' do
      it "updates user's details"
      it "replies with updated user's details"
    end

    context 'with invalid parameters' do
      it "doesn't update user's details"
      it "replies with an error explaining why the user wasn't updated"
    end
  end

  describe 'DELETE destroy' do
    context 'when user has been found' do
      it "deletes user from database"
      it "replies with status :ok"
    end

    context 'when user could not be found' do
      it "replies with status :not_found and an error message"
    end
  end

end
