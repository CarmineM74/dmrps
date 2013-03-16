require 'faker'

FactoryGirl.define do
  factory :location do |f|
    f.descrizione { Faker::Company.name }
    f.indirizzo { 'Yellow submarine lane, 1'}
    f.citta { 'Nowhereland' }
    f.cap { '01000' }
    f.provincia { 'ZZ' }
    f.telefono { Faker::PhoneNumber.phone_number }
    f.fax { Faker::PhoneNumber.phone_number }
    client
  end
end
