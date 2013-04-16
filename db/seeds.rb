# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Adding default Admin user
user = User.create(email:'admin@changeme.com',password:'testme',password_confirmation:'testme', role: 'admin')

# Test SEEDS
# Adding a bunch of users
%w{ user1 user2 user3 user4 }.each do |u|
  User.create(email:"#{u}@seeds.com",password:u,password_confirmation:u, role: 'user')
end

# Adding clients and locations
fc = Client.new
fc.ragione_sociale = 'FrigoCaserta srl'
fc.indirizzo = 'Viale J. Maria Escriva'
fc.citta = 'Caserta'
fc.cap = '81025'
fc.provincia = 'CE'
fc.partita_iva = '12345'
fc.tipo_contratto = 'Orario'
fc.costo = 10.0
fc.inizio = DateTime.now
fc.fine = 1.year.from_now
fc.diritto_di_chiamata = true
fc.costo_diritto_chiamata = 20.0
fc.save
fc_magazzini = Location.new
fc_magazzini.descrizione = 'Magazzini frigoriferi'
fc_magazzini.indirizzo = 'Strada provinciale snc'
fc_magazzini.citta = 'Gricignano di Aversa'
fc_magazzini.provincia = 'CE'
fc_magazzini.cap = '81030'
fc_magazzini.client = fc
fc_magazzini.save

# Adding a bunch of contacts
['Carmine Moleti','Franco Melardo','Vincenzo Bosco','Saverio Bosco'].each do |c|
  contact = Contact.new
  contact.name = c
  contact.email = c.gsub(' ','.').downcase + '@frigocaserta.it'
  contact.phone = '123456'
  contact.notes = 'Artificially crafted'
  contact.client = fc
  contact.save
end

# Adding fake activities
(1..10).each do |n|
  a = Activity.new
  a.descrizione = "Attivita' predefinita Nr. #{n}"
  a.save
end

# Adding fake interventions
(1..4).each do |n|
  i = Intervention.new
  i.user = User.where(email: "user#{n}@seeds.com").first
  i.locations << fc_magazzini
  i.data_inoltro_richiesta = DateTime.now
  i.data_intervento = 1.day.from_now
  i.contatto = 'Carmine Moleti'
  i.email = 'ced@frigocaserta.it'
  i.descrizione_anomalie = "Test N.#{n}"
  i.descrizione_intervento = 'Risoluzione problemi di configurazione'
  (1..3).each { |x| i.activities << Activity.find(x) }
  i.diritto_di_chiamata = fc.diritto_di_chiamata
  i.inizio = i.data_intervento

  ore = Random.rand(10)+1

  i.fine = i.inizio + ore.hours
  i.lavoro_completato = true
  i.ore_lavorate_cliente = ore
  i.ore_lavorate_remoto = Random.rand(3)
  i.ore_lavorate_laboratorio = Random.rand(7)
  i.note = 'nulla da dichiarare'
  i.save
end


