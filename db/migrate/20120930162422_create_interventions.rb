class CreateInterventions < ActiveRecord::Migration
  def change
    create_table :interventions do |t|
      t.references :user
      t.date :data_inoltro_richiesta
      t.date :data_intervento
      t.datetime :inizio, null: false, default: Time.now
      t.datetime :fine, null: false, default: 1.hours.from_now
      t.string :email
      t.string :contatto
      t.text :descrizione_anomalie
      t.text :descrizione_intervento
      t.decimal :ore_lavorate_cliente, precision: 10, scale: 2, default: 0.0
      t.decimal :ore_lavorate_laboratorio, precision: 10, scale: 2, default: 0.0
      t.decimal :ore_lavorate_remoto, precision: 10, scale: 2, default: 0.0
      t.text :appunti
      t.boolean :lavoro_copmletato, null: false, default: false
      t.string :note
      t.boolean :diritto_di_chiamata, null: false, default: false
      t.timestamps
    end
  end
end
