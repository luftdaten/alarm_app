class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :name
      t.integer :user_id
      t.boolean :enabled
      t.float :limit_value
      t.datetime :last_send

      t.timestamps
    end
  end
end
