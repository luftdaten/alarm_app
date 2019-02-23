class CreateOwnSensors < ActiveRecord::Migration[5.0]
  def change
    create_table :own_sensors do |t|
      t.string :kind
      t.integer :extern_db_id
      t.string :provider
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
