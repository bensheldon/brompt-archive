# frozen_string_literal: true

RSpec.describe SendFeedReminderMessages do
  let!(:reminder) { create(:reminder, remind_after_days: 1, repeat_remind_after_days: 3) }
  let!(:unconfirmed_reminder) { create(:reminder, remind_after_days: 1, repeat_remind_after_days: 3, feed_url: reminder.feed_url, user: create(:user, :unconfirmed)) }
  let(:feed) { reminder.feed }

  context 'when feed has no items' do
    it "doesn't send a message" do
      allow(ReminderMessageMailer).to receive(:reminder)
      allow(ReminderMessageMailer).to receive(:repeat_reminder)

      expect { described_class.new.call(feed) }
        .not_to change(ReminderMessage, :count)

      expect(ReminderMessageMailer).not_to have_received(:reminder)
      expect(ReminderMessageMailer).not_to have_received(:repeat_reminder)
    end
  end

  context 'when last item is older than reminder days' do
    before do
      feed_item = build(:feed_item, published_at: (reminder.remind_after_days + 10).days.ago)
      feed.items << feed_item
    end

    context 'when no messages have ever been sent' do
      it 'sends a reminder' do
        expect(ReminderMessageMailer).to \
          receive_message_chain(:reminder, :deliver_later)

        expect { described_class.new.call(feed) }
          .to change(ReminderMessage, :count).by(1)
      end
    end

    context 'when a message has been sent recently' do
      before { create(:reminder_message, reminder: reminder) }

      it "doesn't send a reminder" do
        allow(ReminderMessageMailer).to receive_messages(reminder: nil, repeat_reminder: nil)

        expect { described_class.new.call(feed) }
          .not_to change(ReminderMessage, :count)

        expect(ReminderMessageMailer).not_to have_received(:reminder)
        expect(ReminderMessageMailer).not_to have_received(:repeat_reminder)
      end
    end

    context 'when a message has been sent and there is a repeat reminder' do
      before { create(:reminder_message, reminder: reminder, created_at: 5.days.ago) }

      it "sends a reminder" do
        expect(ReminderMessageMailer).to \
          receive_message_chain(:repeat_reminder, :deliver_later)

        expect { described_class.new.call(feed) }
          .to change(ReminderMessage, :count).by(1)
      end
    end

    context 'when a message has been sent and re-reminders are disabled' do
      let(:reminder) { create(:reminder, remind_after_days: 1, repeat_remind_after_days: nil) }

      before { create(:reminder_message, reminder: reminder, created_at: 5.days.ago) }

      it "does not sends a reminder" do
        allow(ReminderMessageMailer).to receive(:reminder)
        allow(ReminderMessageMailer).to receive(:repeat_reminder)

        expect { described_class.new.call(feed) }
          .not_to change(ReminderMessage, :count)

        expect(ReminderMessageMailer).not_to have_received(:reminder)
        expect(ReminderMessageMailer).not_to have_received(:repeat_reminder)
      end
    end
  end
end
