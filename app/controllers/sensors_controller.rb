class SensorsController < ApplicationController
  #skip_before_action :authenticate_request
  def index #used for display on selection map
    @sensors = OwnSensor.where.not(latitude: nil, longitude: nil).where(kind: "SDS011")
    @markers = []
    @sensors.each do |s|
      #@markers << { latlng: [s.latitude, s.longitude], popup: sensor }
      @markers << {lat: s.latitude, lng: s.longitude, id: s.extern_db_id, name: s.kind }

    end
    respond_to do |format|
      format.html { }
      format.json { render json: { sensors: @markers.to_json } }
    end
    #puts @markers
   # render json: { sensors: @sensors }
  end
end
