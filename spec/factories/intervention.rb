# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :intervention do
    user
    after(:build) do |intervention, evaluator|
      FactoryGirl.create_list(:location,1,intervention: intervention)
    end
    data_inoltro_richiesta { Date.today }
    data_intervento { Date.today }
    inizio { Time.now }
    fine { 2.hours.since }
    email { "mr_wolf@fixer.com"}
    contatto "Mr Wolf"
    descrizione_anomalie { "Cadavere spiaccicato sul sedile dell'auto" }
    descrizione_intervento { "Risoluzione del problema" }
    ore_lavorate_cliente { 10.2 }
    ore_lavorate_remoto { 0.0 }
    ore_lavorate_laboratorio { 1.5 }
    appunti { "Nessuno" }
    lavoro_completato { true }
    note { "Fate esattamente quello che vi dico" }
    diritto_di_chiamata { true }
  end
end
