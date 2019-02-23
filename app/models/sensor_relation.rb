class SensorRelation < ActiveRecord::Base
  belongs_to :own_sensor#, :class_name => 'MySensor', :foreign_key => 'my_sensor_id'  # todo naming own_sensors?
  belongs_to :notification
end
