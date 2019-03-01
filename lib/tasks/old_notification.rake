
namespace :old_notification do
  desc "send notification PM10"
  task send_mail: :environment do
    request = URI.parse("https://openair.cologne.codefor.de/influx_api?u=#{ENV["INFLUX_USER"]}&p=#{ENV["INFLUX_PASS"]}&db=feinstaub&q=SELECT mean(P1) FROM feinstaub WHERE  time >= now() - 3h GROUP BY feed")
    @answer = Net::HTTP.get_response(request)
    if @answer.code == "301"
     @answer = Net::HTTP.get_response(URI.parse(@answer.header['location']))
    end

    data = JSON.parse(@answer.body)



    def parse_results(data)
      sensor_results_pm10 = {}
      puts data["results"][1]
      data["results"][0]["series"].each do |sensor|
        sensor_results_pm10[sensor['tags']['feed']] = sensor["values"][0][1]
      end
      return sensor_results_pm10
    end

    def get_notifications(sensor_results)
      Notification.joins(:sensors).where(enabled: true).each do |notification|
        sum = 0
        notification.sensors.each do |sensor|
          sum += sensor_results["sensor-#{sensor.extern_db_id}"].to_i
        end
        mean = sum/notification.sensors.count
        if mean >= 30
          puts 'alarm', notification.user.email, notification.name
          send_mail(notification, mean)
        end
      end
    end

    def send_last_10h?(notification)
      if notification.last_send.blank?
        false
      else
        notification.last_send < Time.now - 12.hour
      end
    end

    def send_mail(notification, mean)
      if not send_last_10h?(notification)
        UserMailer.notification_email(notification, mean).deliver
        notification.update_attribute(:last_send, Time.now)
      end
    end

    unless data["results"].blank?
      sensor_results = parse_results(data)
      filtered_notifivation = get_notifications(sensor_results)
    end

  end
end
