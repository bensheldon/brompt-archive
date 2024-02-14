# frozen_string_literal: true

class FeedRemindersJob < ApplicationJob
  def perform(feed)
    FetchFeedService.new.call(feed)
    feed.save!
    feed.reload

    return if feed.errored_at.present?

    new_items_count = feed.items.size { |item| !item.persisted? }
    Rails.logger.info("FeedRemindersJob: Still #{new_items_count} unsaved items from feed=#{feed.id}")

    SendFeedReminderMessages.new.call(feed)
  end
end
