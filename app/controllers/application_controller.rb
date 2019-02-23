class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :redirect_url
  before_action :set_mailer_host

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = ENV["DOMAIN"] unless Rails.env.development?
  end

  def redirect_url
    return new_patron_session_path unless patron_signed_in?
    case current_patron
      when User
        sensors_path
      when Admin
        root_path
    end
  end

end
