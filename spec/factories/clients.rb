require 'faker'

FactoryGirl.define do
  factory :client do |f|
    f.ragione_sociale { Faker::Company.name}
    f.indirizzo { 'Yellow submarine lane, 1'}
    f.citta { 'Nowhereland' }
    f.cap { '01000' }
    f.provincia { 'ZZ' }
    f.partita_iva '1234567890'
    f.codice_fiscale ''
  end
end
