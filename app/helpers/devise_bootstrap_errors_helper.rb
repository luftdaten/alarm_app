module DeviseBootstrapErrorsHelper
  def devise_bootstrap_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t('errors.messages.not_saved',
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div class="column">
      <h5>#{sentence}</h5>
      <ul class="red column flash">#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
end