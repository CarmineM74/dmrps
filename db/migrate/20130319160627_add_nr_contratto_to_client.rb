class AddNrContrattoToClient < ActiveRecord::Migration
  def change
    add_column :clients, :nr_contratto, :string
  end
end
