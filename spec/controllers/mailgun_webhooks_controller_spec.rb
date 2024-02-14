# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailgunWebhooksController, type: :controller do
  let(:reminder_message) { create(:reminder_message) }

  around do |example|
    Timecop.freeze { example.run }
  end

  describe '#create' do
    it 'updates a reminder message' do
      expect do
        post :create, params: webhook_params(event: 'opened', reminder_message_uuid: reminder_message.uuid)
      end.to change { reminder_message.reload.opened_at }.from(nil).to be_within(1.second).of(Time.current)
    end
  end

  def webhook_params(event:, reminder_message_uuid:)
    {
      "signature" => {
        "timestamp" => "1539229489",
        "token" => "f1cd6fde8ddab653989dcfe48b0d88735bf3fc6f3019504811",
        "signature" => "7c1744a6f04ced361a7bdaff928a8f35fa49696716c9371827f8aae8a0869dbc",
      },
      "event-data" => {
        "geolocation" => { "country" => "US", "region" => "CA", "city" => "San Francisco" },
        "tags" => %w[my_tag_1 my_tag_2],
        "ip" => "50.56.129.169",
        "recipient-domain" => "example.com",
        "id" => "Ase7i2zsRYeDXztHGENqRA",
        "campaigns" => [],
        "user-variables" => {
          "reminder_message_uuid" => reminder_message_uuid,
          "my-var-2" => "awesome",
        },
        "log-level" => "info",
        "timestamp" => Time.current.to_i,
        "client-info" => { "client-name" => "Chrome", "client-os" => "Linux", "user-agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.43 Safari/537.31", "device-type" => "desktop", "client-type" => "browser" }, "message" => { "headers" => { "message-id" => "20130503182626.18666.16540@brompt.com" } },
        "recipient" => "alice@example.com",
        "event" => event
      },
    }
  end
end
