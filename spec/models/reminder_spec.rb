# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reminder, type: :model do
  describe '.confirmed' do
    let(:confirmed_reminder) { create(:reminder) }
    let(:unconfirmed_reminder) { create(:reminder, user: create(:user, :unconfirmed)) }

    it 'only includes confirmed reminders' do
      expect(described_class.confirmed).to include confirmed_reminder
      expect(described_class.confirmed).not_to include unconfirmed_reminder
    end
  end

  describe '#feed_url' do
    it 'prevents empty string feed_urls' do
      reminder = build(:reminder, feed_url: '')
      expect(reminder).not_to be_valid
    end
  end

  describe '#feed' do
    let(:feed_url) { Faker::Internet.url }

    it "associates a feed" do
      reminder = create(:reminder, feed_url: feed_url)
      expect(reminder.feed).to be_present
      expect(reminder.feed).to be_persisted
      expect(reminder.feed.url).to eq feed_url
    end

    it "creates a feed if one doesn't exist" do
      expect do
        create(:reminder, feed_url: feed_url)
      end.to change(Feed, :count).by(1)
    end

    it "reuses an existing feed if it exists" do
      create(:feed, url: feed_url)

      expect do
        create(:reminder, feed_url: feed_url)
      end.not_to change(Feed, :count)
    end
  end

  describe '#latest_message_sent_at' do
    it 'returns when most recent message was sent' do
      reminder = create(:reminder)
      newer_message = Timecop.travel 1.day.ago do
        create(:reminder_message, reminder: reminder)
      end

      _older_message = Timecop.travel 2.days.ago do
        create(:reminder_message, reminder: reminder)
      end

      newer_message.reload
      expect(reminder.latest_message_sent_at).to eq newer_message.sent_at
    end
  end

  describe 'user creation limit' do
    let(:user) { create(:user) }

    context 'when at the maximum numnber of reminders' do
      before do
        create_list(:reminder, user.reminders_count_limit, user: user)
      end

      it 'adds a validatio error on create' do
        reminder = build(:reminder, user: user)

        expect(reminder.save).to be false
        expect(reminder.errors.messages[:base]).to eq ["You cannot create more reminders."]
      end
    end
  end
end
