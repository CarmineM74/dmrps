class AddKmSupplementariToIntervention < ActiveRecord::Migration
  def change
    add_column :interventions, :km_supplementari, :integer
  end
end
