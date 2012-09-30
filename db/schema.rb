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

ActiveRecord::Schema.define(:version => 20120930164610) do

# Could not dump table "clients" because of following StandardError
#   Unknown type 'bool' for column 'diritto_di_chiamata'

  create_table "locations", :force => true do |t|
    t.integer  "client_id"
    t.string   "descrizione"
    t.string   "indirizzo"
    t.string   "cap"
    t.string   "citta"
    t.string   "provincia"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "rps", :force => true do |t|
    t.integer  "location_id"
    t.integer  "user_id"
    t.date     "data_inoltro_richiesta"
    t.date     "data_intervento"
    t.datetime "inizio",                                                  :default => '2012-09-30 16:39:31', :null => false
    t.datetime "fine",                                                    :default => '2012-09-30 17:39:31', :null => false
    t.string   "email"
    t.string   "contatto"
    t.text     "descrizione_anomalie"
    t.text     "descrizione_intervento"
    t.decimal  "ore_lavorate_cliente",     :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ore_lavorate_laboratorio", :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "ore_lavorate_remoto",      :precision => 10, :scale => 2, :default => 0.0
    t.text     "appunti"
    t.boolean  "lavoro_copmletato",                                       :default => false,                 :null => false
    t.string   "note"
    t.boolean  "diritto_di_chiamata",                                     :default => false,                 :null => false
    t.datetime "created_at",                                                                                 :null => false
    t.datetime "updated_at",                                                                                 :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
