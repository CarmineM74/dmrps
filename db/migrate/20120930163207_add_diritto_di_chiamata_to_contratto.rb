class AddDirittoDiChiamataToContratto < ActiveRecord::Migration
  def up
    add_column :clients, :diritto_di_chiamata, :boolean, null: false, default: false
    Client.reset_column_information
    say_with_time "Updating client's contract diritto di chiamata ..." do
      Client.update_all(diritto_di_chiamata: false)
    end
  end

  def down
    remove_column :clients, :diritto_di_chiamata
  end

end
