class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.references :client
      t.string :descrizione, null: false
      t.string :tipo, null: false, default: 'Orario'
      t.decimal :costo, precision: 10, scale: 2, null: false, default: 0
      t.date :inizio, null: false, default: Date.today
      t.date :fine, null: false, default: 1.years.since
      t.timestamps
    end
    add_index :contracts, :client_id
  end
end
