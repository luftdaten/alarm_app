module DefaultUrlOptions

  def default_url_options
    {
      :host => host,
      :port => port
    }
  end

  private
  def host
    Rails.env.development? ? "0.0.0.0" : ENV['DOMAIN']
  end

  def port
   Rails.env.development? ? 3000 : 80
  end

end