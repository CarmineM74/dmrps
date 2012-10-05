class CreateInterventionsLocationsJoinTable < ActiveRecord::Migration
  def up
    create_table :interventions_locations do |t|
      t.references :location
      t.references :intervention
    end
  end

  def down
    drop_table :interventions_locations
  end
end
