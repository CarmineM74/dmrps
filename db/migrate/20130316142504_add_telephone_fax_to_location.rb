class AddTelephoneFaxToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :telefono, :string
    add_column :locations, :fax, :string
  end
end
