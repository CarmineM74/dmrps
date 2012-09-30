class AddContractInfoToClient < ActiveRecord::Migration
  def change
    add_column :clients, :tipo_contratto, :string, null: false, default: 'Orario'
    add_column :clients, :costo, :decimal, null: false, precision: 10, scale: 2, default: 0
    add_column :clients, :inizio, :datetime, null: false, default: Date.today
    add_column :clients, :fine, :datetime, null: false, default: 1.years.since

    Client.reset_column_information
    say_with_time "Updating clients' contract info..." do
      Client.update_all(tipo_contratto: 'Orario', costo: 0)
    end
  end
end
