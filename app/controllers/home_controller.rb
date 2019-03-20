class HomeController < ApplicationController
  def index
    #@sensors = OwnSensor.where.not(latitude: nil, longitude: nil).where(kind: "SDS011")
    #@markers = []
    #@sensors.each do |s|
    #  @markers << {
    #    lat: s.latitude,
    #    lng: s.longitude,
    #    id: s.extern_db_id,
    #    name: s.kind,
    #    problem: ''
    #  }
    #end
  end

  def impressum
  end

  def datenschutz
  end
end
