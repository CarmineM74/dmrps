class CreatePermissionsUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :permissions_users, id: false do |t|
      t.references :user
      t.references :permission
    end
  end
end
