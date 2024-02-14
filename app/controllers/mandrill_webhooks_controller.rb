# frozen_string_literal: true
class MandrillWebhooksController < ActionController::Base # rubocop:disable Rails/ApplicationController
  include Mandrill::Rails::WebHookProcessor

  def handle_delivered(event_payload)
    reminder_message = find_reminder_message(event_payload)
    return if reminder_message.blank?

    reminder_message.touch(:delivered_at) if reminder_message.delivered_at.blank?
  end

  def handle_open(event_payload)
    reminder_message = find_reminder_message(event_payload)
    return if reminder_message.blank?

    reminder_message.touch(:opened_at) if reminder_message.opened_at.blank?
  end

  def handle_click(event_payload)
    reminder_message = find_reminder_message(event_payload)
    return if reminder_message.blank?

    reminder_message.touch(:clicked_at) if reminder_message.clicked_at.blank?
  end

  def handle_spam(event_payload)
    reminder_message = find_reminder_message(event_payload)
    return if reminder_message.blank?

    reminder_message.touch(:complained_at) if reminder_message.complained_at.blank?
  end

  def authenticate_mandrill_request!
    true
  end

  def find_reminder_message(event_payload)
    uuid = event_payload.metadata['reminder_message_uuid'] || event_payload.metadata['reminder_message_id']
    ReminderMessage.find_by(uuid: uuid)
  end
end
