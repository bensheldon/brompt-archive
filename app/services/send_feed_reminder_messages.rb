# frozen_string_literal: true

class SendFeedReminderMessages
  def call(feed)
    return if feed.latest_item_published_at.blank?

    feed.reminders.confirmed.find_each do |reminder|
      next if feed.latest_item_published_at > reminder.remind_after_days.days.ago

      if reminder.latest_message_sent_at.blank? || feed.latest_item_published_at > reminder.latest_message_sent_at
        message = reminder.messages.create(type: :reminder)
        ReminderMessageMailer.reminder(message).deliver_later
      elsif reminder.repeat_remind_after_days.present? && reminder.latest_message_sent_at < reminder.repeat_remind_after_days.days.ago
        message = reminder.messages.create(type: :repeat_reminder)
        ReminderMessageMailer.repeat_reminder(message).deliver_later
      end
    end
  end
end
