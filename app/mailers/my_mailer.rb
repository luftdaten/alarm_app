class MyMailer < Devise::Mailer
  require 'net/http'
  require 'openssl'
  require 'resolv-replace'
  default from: ENV['MAIL']
  include DefaultUrlOptions
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  #default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
end