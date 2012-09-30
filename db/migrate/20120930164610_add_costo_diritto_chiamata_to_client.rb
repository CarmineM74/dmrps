class AddCostoDirittoChiamataToClient < ActiveRecord::Migration
  def up
    add_column :clients, :costo_diritto_chiamata, :decimal, precision: 10, scale: 2, null: false, default: 0.0
    Client.reset_column_information
    say_with_time "Updating costo_diritto_chiamata in client's contract info" do
      Client.update_all(costo_diritto_chiamata: 0.0)
    end
  end

  def down
    remove_column :clients, :costo_diritto_chiamata
  end

end
