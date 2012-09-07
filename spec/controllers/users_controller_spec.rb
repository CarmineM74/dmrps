require 'spec_helper'

describe UsersController do

  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'fetches all the users from the database'   
  end

  describe 'POST create' do
    context 'with valid parameters' do
    end

    context 'with invalid parameters' do
    end
  end

  describe 'PUT update' do
    context 'with valid parameters' do
    end

    context 'with invalid parameters' do
    end
  end

  describe 'DELETE destroy' do
    context 'when user has been found' do
    end

    context 'when user could not be found' do
    end
  end

end
