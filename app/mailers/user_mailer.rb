class UserMailer < ApplicationMailer
  default from: ENV['MAIL']

  def sample_email(notification, mean)
    @notification = notification
    @mean = mean
    mail = notification.user.email
    mail(to: mail, subject: 'Sensor Alarm')
  end
end
