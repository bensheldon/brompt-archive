# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReminderMessageMailer, type: :mailer do
  describe '#reminder' do
    let(:reminder) { create(:reminder, :with_feed) }
    let(:reminder_message) { create(:reminder_message, reminder: reminder) }
    let(:mail) { described_class.reminder(reminder_message).deliver_now }

    it 'sends to the reminder email' do
      expect(mail.to).to eq [reminder_message.reminder.user.email]
    end

    it 'has the correct sender' do
      expect(mail.from).to eq ['hello@brompt.com']
    end

    it 'renders the subject' do
      expect(mail.subject).to include 'Reminder for'
    end

    it 'includes the UUID for mailers' do
      json = JSON.parse mail.header['X-Mailgun-Variables'].to_s
      expect(json['reminder_message_uuid']).to eq reminder_message.uuid
    end
  end
end
