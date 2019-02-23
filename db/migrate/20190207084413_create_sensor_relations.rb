class CreateSensorRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :sensor_relations do |t|
      t.integer :notification_id
      t.integer :own_sensor_id

      t.timestamps
    end
  end
end
