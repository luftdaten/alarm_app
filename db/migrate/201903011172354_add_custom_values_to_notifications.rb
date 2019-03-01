class AddCustomValuesToNotifications < ActiveRecord::Migration[5.1]
  def up
    add_column :notifications, :aggregation_time, :integer, default: 3
    add_column :notifications, :interval_to_send, :integer, default: 10
    change_column :notifications, :limit_value, :integer, default: 50
  end

  def down
    remove_column :notifications, :aggregation_time
    remove_column :notifications, :interval_to_send
    change_column :notifications, :limit_value, :float
  end
end
