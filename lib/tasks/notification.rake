
namespace :notification do
  desc "send notification PM10"
  task send_mail: :environment do

    def get_influx_data(aggregation_time)
      request = URI.parse("https://openair.cologne.codefor.de/influx_api?u=#{ENV["INFLUX_USER"]}&p=#{ENV["INFLUX_PASS"]}&db=feinstaub&q=SELECT mean(P1) FROM feinstaub WHERE  time >= now() - #{aggregation_time}h GROUP BY feed")
      @answer = Net::HTTP.get_response(request)
      if @answer.code == "301"
      @answer = Net::HTTP.get_response(URI.parse(@answer.header['location']))
      end
      data = JSON.parse(@answer.body)
    end

    def parse_results(data)
      sensor_results_pm10 = {}
      puts data["results"][1]
      data["results"][0]["series"].each do |sensor|
        sensor_results_pm10[sensor['tags']['feed']] = sensor["values"][0][1]
      end
      return sensor_results_pm10
    end

    def send_notifications(sensor_results, aggregation_time)
      notifications = Notification.joins(:sensors).
        where(enabled: true, aggregation_time: aggregation_time).uniq
      notifications.each do |notification|
        sum = 0
        mean = 0
        notification.sensors.each do |sensor|
          sum += sensor_results["sensor-#{sensor.extern_db_id}"].to_i
        end
        mean = sum/notification.sensors.count
        custom_limit_value = notification.limit_value || 50
        puts "Mean #{ mean} Limit: #{custom_limit_value}"
        if mean >= custom_limit_value
          deliver_mail(notification, mean) if correct_interval_to_send?(notification)
        end
      end
    end

    def correct_interval_to_send?(notification)
      if notification.last_send.blank?
        true
      else
        Time.now - notification.interval_to_send.hour > notification.last_send
      end
    end

    def deliver_mail(notification, mean)
      puts "Alarm: #{ notification.user.email } #{notification.name} #{mean}"
      UserMailer.notification_email(notification, mean).deliver
      notification.update_attribute(:last_send, Time.now)
    end

    aggregation_times = Notification.joins(:sensors).
      where(enabled: true).pluck(:aggregation_time).uniq.sort

    aggregation_times.each do |aggregation_time|
      #puts "Aggregation time: #{aggregation_time}h"
      data = get_influx_data(aggregation_time)
      unless data["results"].blank?
        sensor_results = parse_results(data)
        send_notifications(sensor_results, aggregation_time)
        #puts "End of aggregation time: #{aggregation_time}h"
      end
    end

  end
end
