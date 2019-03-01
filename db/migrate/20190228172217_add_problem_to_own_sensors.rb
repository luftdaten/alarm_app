class AddProblemToOwnSensors < ActiveRecord::Migration[5.1]
  def change
    add_column :own_sensors, :problem, :string
  end
end
