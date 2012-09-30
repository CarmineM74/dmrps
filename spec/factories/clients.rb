require 'faker'

FactoryGirl.define do
  factory :client do |f|
    f.ragione_sociale { Faker::Company.name}
    f.indirizzo { 'Yellow submarine lane, 1'}
    f.citta { 'Nowhereland' }
    f.cap { '01000' }
    f.provincia { 'ZZ' }
    f.partita_iva { '1234567890' }
    f.codice_fiscale {''}
    f.tipo_contratto {'Orario'}
    f.costo {10.0}
    f.inizio {Date.today}
    f.fine {1.years.since}
    f.diritto_di_chiamata { true }
    f.costo_diritto_chiamata { 20.0 }
  end
end
