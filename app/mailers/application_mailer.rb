# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "Brompt <hello@brompt.com>"
  layout 'mailer'

  def simple(to:, subject:, body:)
    @body = body
    mail(to: to, subject: subject)
  end
end
