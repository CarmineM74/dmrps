class CreateActivitiesInterventions < ActiveRecord::Migration
  def up
    create_table :activities_interventions do |t|
      t.references :activity
      t.references :intervention
    end
  end

  def down
    drop_table :activities_interventions
  end
end
