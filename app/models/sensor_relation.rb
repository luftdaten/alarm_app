class SensorRelation < ActiveRecord::Base
  belongs_to :own_sensor
  belongs_to :notification
end
