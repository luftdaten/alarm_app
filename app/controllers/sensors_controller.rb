class SensorsController < ApplicationController
  #skip_before_action :authenticate_request
  def index #used for display on selection map
    @sensors = OwnSensor.where.not(latitude: nil, longitude: nil).where(kind: "SDS011")
    @markers = []
    @sensors.each do |s|
      @markers << {
        lat: s.latitude,
        lng: s.longitude,
        id: s.extern_db_id,
        name: s.kind,
        problem: sensor_problem(s.problem.to_s)
      }

    end
    respond_to do |format|
      format.html { }
      format.json { render json: { sensors: @markers.to_json } }
    end
    #puts @markers
   # render json: { sensors: @sensors }
  end

  def show
    if current_user.blank?
      redirect_to new_user_session_path, notice: "Erst bitte erst einloggen..."
    end
    @sensor = OwnSensor.joins({sensor_relations: {notification: :user}}).
      where({notifications: { user_id: current_user.id}}).where(extern_db_id: params[:id]).first
    sensor_name = "sensor-#{@sensor.extern_db_id}"
    @sensor_problem = sensor_problem(@sensor.problem.to_s)
    request = URI.parse("https://openair.cologne.codefor.de/influx_api?u=#{ENV["INFLUX_USER"]}&p=#{ENV["INFLUX_PASS"]}&db=feinstaub&q=SELECT mean(P1) FROM feinstaub WHERE feed = #{quotify(sensor_name)} AND time >= now() - 10d GROUP BY time(3h) fill(-1)")
    @answer = Net::HTTP.get_response(request)
    if @answer.code == "301"
     @answer = Net::HTTP.get_response(URI.parse(@answer.header['location']))
    end
    if @answer.code == "200"
      @sensor_data = JSON.parse(@answer.body)['results'][0]['series']
    end
    if !@sensor_data.blank?
      @sensor_chart_data = [{
        name: "Sensor-#{@sensor.extern_db_id}",
        data: @sensor_data[0]['values'].
          map.with_index { |data, index|
            value = data[1] > 0 ? data[1].to_f.round(2) : nil
            [I18n.localize(DateTime.parse(data[0]).to_time, format: :chart), value]
          }
      }]
    end
  end

  private
  def quotify(val)
    "'"+val+"'"
  end

  def sensor_problem(problem)
    { noValue: "Es wird kein Wert gesendet <br>(der Wert ist immer 0).",
      tooSmall: "Der Wert ist immer sehr klein <br>(Mittelwert P10 < 1).",
      tooBig: "Der Wert ist immer am oberen Anschlag <br>(Mittelwert P10 > 1990).",
      tooFlat: "Der Wert hat sich über den ganzen Tag nicht oder kaum geändert <br>(Standardabweichung P10 < 1).",
      p2tooBig: "Der Wert für P2.5 ist unplausibel groß <br>(Mittelwert P2.5 > 50).",
      tooNarrow: "P10 und P2.5 liegen den ganzen Tag zu nahe beieinander <br>((MW P10 - MW P2.5) / MW P2.5 < 0.12).",
      tooBroad: "Die Werte für P10 und P2.5 liegen den ganzen Tag zu weit auseinader <br>((MW P10 - MW P2.5) / MW P2.5 > 10).",
      m30tooFlat: "Der 30min-Mittelwert für den ganzen Tag ist zu gleichförmig <br>(Standardabweichung vom MW30 < 0.5).",
      tooFlat_1: "Die normierte Standardabweichung ist zu klein, d.h. die normierte Welligkeit ist zu gering <br>(Standarsabweichung P10 / Mittelwert P10 ) < 0.1"
    }[problem.to_sym] || ''
  end

end
