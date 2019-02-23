class ApiController < ActionController::Base
  layout 'blank'

  def show
    @sensors = OwnSensor.where(kind: "SDS011").select(:kind, :extern_db_id,:provider, :latitude, :longitude)
    render json: { sensors: @sensors }
  end

  def sensors_notification_enabled #used for nodered selection and influx push
    sensor_ids = OwnSensor.joins({:sensor_relations => :notification}).where({:notifications => { enabled: true }}).map(&:extern_db_id)
    render json: { sensor_ids: sensor_ids }
  end

end