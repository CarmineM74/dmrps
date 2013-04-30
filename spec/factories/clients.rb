require 'faker'

FactoryGirl.define do
  factory :client do 
    ragione_sociale { Faker::Company.name}
    indirizzo { 'Yellow submarine lane, 1'}
    citta { 'Nowhereland' }
    cap { '01000' }
    provincia { 'ZZ' }
    sequence(:partita_iva) { |n| "1234567890_#{n}" }
    sequence(:codice_fiscale) { |n| "#{n}" }
    tipo_contratto {'Orario'}
    costo {10.0}
    inizio {Date.today}
    fine {1.years.since}
    diritto_di_chiamata { true }
    costo_diritto_chiamata { 20.0 }
    nr_contratto { '' }

    factory :client_with_associations do
      after(:build) do |client, evaluator|
        client.contacts = FactoryGirl.build_list(:contact,5, client: client)
        client.locations = FactoryGirl.build_list(:location,5,client: client)
      end
      after(:create) do |client, evaluator|
        client.contacts = FactoryGirl.create_list(:contact,5, client: client)
        client.locations = FactoryGirl.create_list(:location,5,client: client)
      end
    end
  end
end
