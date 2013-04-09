FactoryGirl.define do
  factory :contact do
    name { Faker::Name.name } 
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    notes "These are just notes"
    client
  end
end
