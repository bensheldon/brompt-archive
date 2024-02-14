# frozen_string_literal: true
# https://github.com/plataformatec/devise/blob/master/app/mailers/devise/mailer.rb
class DeviseMailer < Devise::Mailer
  from_email = "Brompt <hello@#{Rails.configuration.action_mailer.default_url_options[:host]}>"
  default(
    from: from_email,
    reply_to: from_email,
    template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  )

  def confirmation_instructions(record, token, opts = {})
    opts[:subject] = 'Confirm your email address ✅'
    super(record, token, opts)
  end

  def template_paths
    'devise_mailer'
  end
end
