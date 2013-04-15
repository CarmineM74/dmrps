require 'faker'

FactoryGirl.define do
  factory :activity do 
    sequence(:descrizione) { |n| "Descrizione attivita Nr. #{n}" }
  end
end
