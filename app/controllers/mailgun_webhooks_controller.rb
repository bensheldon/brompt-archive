# frozen_string_literal: true

class MailgunWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  # before_action :verify_webhook

  def create
    event_type = params[:'event-data'][:event]
    event_timestamp = params[:'event-data'][:timestamp]
    custom_variables = params[:'event-data'][:'user-variables']
    reminder_message_uuid = custom_variables[:reminder_message_uuid]

    reminder_message = ReminderMessage.find_by uuid: reminder_message_uuid
    reminder_message.update! "#{event_type}_at": Time.zone.at(event_timestamp.to_i) if reminder_message && %w[delivered opened clicked complained].include?(event_type)

    head :no_content
  end

  private

  def verify_webhook
    api_key   = Rails.application.secrets.mailgun_api_key
    signature = params.fetch('signature')
    timestamp = params.fetch('timestamp')
    token     = params.fetch('token')
    digest    = OpenSSL::Digest.new('sha256')

    signature == OpenSSL::HMAC.hexdigest(digest, api_key, format('%s%s', timestamp, token)) # rubocop:disable Style/FormatStringToken
  end
end
