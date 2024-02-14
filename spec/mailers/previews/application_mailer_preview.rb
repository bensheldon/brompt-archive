# frozen_string_literal: true

class ApplicationMailerPreview < ActionMailer::Preview
  def simple
    user = FactoryBot.create(:user)
    ApplicationMailer.simple(
      to: ApplicationMailer.email_address_with_name(user.email, user.first_name),
      subject: "Hello",
      body: "Something\nElse"
    )
  end
end
