class AddIndexNotificationIdAndOwnSensorIdToSensorRelations < ActiveRecord::Migration[5.1]
  def change
    add_index :sensor_relations, [:own_sensor_id, :notification_id], unique: true
  end
end
