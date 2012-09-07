require 'spec_helper'

describe User do
  it 'has a valid factory' do
    FactoryGirl.create(:user).should be_valid
  end

  it 'requires an email' do
    FactoryGirl.build(:user,email: nil).should_not be_valid
  end

  it 'requires a password' do
    FactoryGirl.build(:user,password: nil).should_not be_valid
  end

  it "fails when password and password_confirmation don't match" do
    FactoryGirl.build(:user,password_confirmation: '').should_not be_valid
  end

  it 'fails if email already exists' do
   user_one = FactoryGirl.create(:user)
   user_two = FactoryGirl.build(:user, email: user_one.email).should_not be_valid
  end
end
