class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :ragione_sociale, :null => false
      t.string :indirizzo
      t.string :cap
      t.string :citta
      t.string :provincia
      t.string :partita_iva, :null => false
      t.string :codice_fiscale

      t.timestamps
    end
  end
end
