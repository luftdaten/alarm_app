class UserMailer < ApplicationMailer
  include DefaultUrlOptions
  default from: ENV['MAIL']

  def notification_email(notification, mean)
    @notification = notification
    @mean = mean
    mail = notification.user.email
    mail(to: mail, subject: "Sensor Alarm von #{notification.name} mit #{ @mean } µg/m³")
  end
end
