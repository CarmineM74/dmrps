class AddCostoDirittoChiamataToClient < ActiveRecord::Migration
  def change
    add_column :clients, :costo_diritto_chiamata, :decimal, precision: 10, scale: 2, null: false, default: 0.0
    say_with_time "Updating costo_diritto_chiamata in client's contract info" do
      Client.reset_column_information
      Client.update_all(costo_diritto_chiamata: 0.0)
    end
  end
end
