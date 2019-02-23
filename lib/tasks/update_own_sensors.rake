
require 'uri'
require 'yajl/http_stream'
namespace :update do
  desc "send notification PM10"
  task own_sensors: :environment do
    url = URI.parse("http://api.luftdaten.info/static/v2/data.1h.json")
    results = Yajl::HttpStream.get(url)
    results.each do |hash|
      extern_id = hash["sensor"]["id"]
      name = hash["sensor"]["sensor_type"]["name"]
      if name == "SDS011"
       sensor = OwnSensor.find_or_create_by(extern_db_id: extern_id, kind: name)
        sensor.update_attributes(
          latitude: hash["location"]["latitude"], longitude: hash["location"]["longitude"]
        )
      end
    end
  end
end
