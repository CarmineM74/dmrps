require 'spec_helper'

describe UsersController do
  render_views

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

      it 'responds with status 201 (created)' do
        do_post
        response.status.should eq(201)
      end

      it 'renders create.rabl' do
        do_post
        response.should render_template :create
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
        response.status.should eq(422)
      end
    end
  end

  describe 'PUT update' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    def do_put(attrs)
      put :update, :id => @user.id, :user => attrs, :format => 'json'
    end

    it 'finds the requested user' do
      do_put(FactoryGirl.attributes_for(:user))
      assigns(:user).should eq(@user)
    end

    context 'with valid parameters' do
      it "replies with status :ok (200)" do
        do_put(FactoryGirl.attributes_for(:user))
        response.status.should eq(200)
      end

      it "updates user's details" do
        do_put(FactoryGirl.attributes_for(:user, email: 'updated@me.com'))
        @user.reload
        @user.email.should eq('updated@me.com')
      end
    end

    context 'with invalid parameters' do
      describe 'replies with status :unprocessable_entity (422)' do
        after(:each) do
          response.status.should eq(422)
        end

        it "when email is empty" do
          do_put(FactoryGirl.attributes_for(:user, email: ''))
        end

        it "when email is already existing" do
          user2 = FactoryGirl.create(:user, email: 'iamme@me.com')
          do_put(FactoryGirl.attributes_for(:user, email: 'iamme@me.com'))
        end

        it "when password is empty" do
          do_put(FactoryGirl.attributes_for(:user, password: ''))
        end
      end

      it "doesn't update user's details"
    end
  end

  describe 'DELETE destroy' do
    context 'when user has been found' do
      it "deletes user from database"
      it "replies with status :ok"
    end

    context 'when user could not be found' do
      it "replies with status :not_found"
    end
  end

end
