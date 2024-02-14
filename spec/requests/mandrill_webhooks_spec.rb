# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Mandrill Webhooks', type: :request do
  describe '#handle_click' do
    let(:reminder_message) { create(:reminder_message) }
    let(:hook_data) { { event: 'click', reminder_message_uuid: reminder_message.uuid } }
    let(:json) { ERB.new(file_fixture('mandrill_hooks_click.json.erb').read).result_with_hash(hook_data) }

    it 'updates a newsletter delivery appropriately' do
      post '/mandrill_webhook', params: { mandrill_events: json }

      expect(response).to be_successful
      expect(reminder_message.reload.clicked_at).to be_present
    end
  end
end
