# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130319160627) do

  create_table "clients", :force => true do |t|
    t.string   "ragione_sociale",                                                                          :null => false
    t.string   "indirizzo"
    t.string   "cap"
    t.string   "citta"
    t.string   "provincia"
    t.string   "partita_iva",                                                                              :null => false
    t.string   "codice_fiscale"
    t.datetime "created_at",                                                                               :null => false
    t.datetime "updated_at",                                                                               :null => false
    t.string   "tipo_contratto",                                        :default => "Orario",              :null => false
    t.decimal  "costo",                  :precision => 10, :scale => 2, :default => 0.0,                   :null => false
    t.datetime "inizio",                                                :default => '2013-04-11 00:00:00', :null => false
    t.datetime "fine",                                                  :default => '2014-04-11 08:28:37', :null => false
    t.boolean  "diritto_di_chiamata",                                   :default => false,                 :null => false
    t.decimal  "costo_diritto_chiamata", :precision => 10, :scale => 2, :default => 0.0,                   :null => false
    t.string   "nr_contratto"
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "notes"
    t.integer  "client_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "interventions", :force => true do |t|
    t.integer  "user_id"
    t.date     "data_inoltro_richiesta"
    t.date     "data_intervento"
    t.datetime "inizio",                                                  :default => '2013-04-11 08:28:37', :null => false
    t.datetime "fine",                                                    :default => '2013-04-11 09:28:37', :null => false
    t.string   "email"
    t.string   "contatto"
    t.text     "descrizione_anomalie"
    t.text     "descrizione_intervento"
    t.decimal  "ore_lavorate_cliente",     :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ore_lavorate_laboratorio", :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ore_lavorate_remoto",      :precision => 10, :scale => 2, :default => 0.0
    t.text     "appunti"
    t.boolean  "lavoro_completato",                                       :default => false,                 :null => false
    t.string   "note"
    t.boolean  "diritto_di_chiamata",                                     :default => false,                 :null => false
    t.datetime "created_at",                                                                                 :null => false
    t.datetime "updated_at",                                                                                 :null => false
    t.integer  "km_supplementari"
  end

  create_table "interventions_locations", :force => true do |t|
    t.integer "location_id"
    t.integer "intervention_id"
  end

  create_table "locations", :force => true do |t|
    t.integer  "client_id"
    t.string   "descrizione"
    t.string   "indirizzo"
    t.string   "cap"
    t.string   "citta"
    t.string   "provincia"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "telefono"
    t.string   "fax"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "role"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
