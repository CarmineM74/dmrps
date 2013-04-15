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
    contacts
  end
end
