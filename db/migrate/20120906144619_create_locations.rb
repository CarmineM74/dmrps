class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :client_id
      t.string :descrizione
      t.string :indirizzo
      t.string :cap
      t.string :citta
      t.string :provincia

      t.timestamps
    end
  end
end
