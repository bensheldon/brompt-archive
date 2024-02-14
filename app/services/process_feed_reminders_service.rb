# frozen_string_literal: true

class ProcessFeedRemindersService
  def call
    Feed.has_reminders.fetch_ready.find_each do |feed|
      FeedRemindersJob.perform_later(feed)
    end
  end
end
