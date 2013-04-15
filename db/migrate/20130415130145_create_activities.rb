class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :descrizione
      t.timestamps
    end
  end
end
