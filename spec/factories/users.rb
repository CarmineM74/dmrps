require 'faker'

FactoryGirl.define do 
  factory :user do |f|
    f.email { Faker::Internet.email }
    f.role 'client'
    f.password 'supersecret'
    f.password_confirmation 'supersecret'
  end
end
