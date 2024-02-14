# frozen_string_literal: true

class ReminderMessageMailer < ApplicationMailer
  def reminder(message)
    @message = message
    set_headers
    mail to: user_email_address,
         subject: %[Reminder for "#{feed_title}"]
  end

  def repeat_reminder(message)
    @message = message
    set_headers
    mail to: user_email_address,
         subject: %[EXTRA reminder for "#{feed_title}"],
         template_name: 'reminder'
  end

  private

  def user_email_address
    @message.reminder.user.email
  end

  def feed_title
    @message.reminder.feed.title
  end

  def set_headers
    headers["X-Mailgun-Variables"] = {
      reminder_message_uuid: @message.uuid,
      environment: Rails.env,
    }.to_json

    headers["X-MC-Metadata"] = {
      reminder_message_uuid: @message.uuid,
      environment: Rails.env,
    }.to_json
    headers["X-MC-Subaccount "] = Rails.application.secrets.smtp_subaccount if Rails.application.secrets.smtp_subaccount.present?
  end
end
