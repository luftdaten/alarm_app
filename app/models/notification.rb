class Notification < ActiveRecord::Base
  has_many :sensor_relations, dependent: :destroy
  has_many :sensors, :through => :sensor_relations, :source => :own_sensor
  belongs_to :user
  accepts_nested_attributes_for :sensor_relations, allow_destroy: true
end
