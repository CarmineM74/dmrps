class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :rule

      t.timestamps
    end
  end
end
