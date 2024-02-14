# frozen_string_literal: true

class ValidateReminderFeedService
  attr_reader :reminder

  def initialize(input_reminder)
    @reminder = input_reminder
  end

  def call
    if reminder.feed_url.present?
      begin
        found_feed_url = Feedbag.find(reminder.feed_url).first
        reminder.feed_url = found_feed_url if found_feed_url.present?
      rescue StandardError
        nil
      end
    end

    if reminder.valid?
      FetchFeedService.new.call(reminder.feed)
      reminder.errors.add :feed_url, reminder.feed.error_message if reminder.feed.error_message.present?
    end

    reminder.errors.empty?
  end
end
