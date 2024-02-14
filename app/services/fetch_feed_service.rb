# frozen_string_literal: true

class FetchFeedService
  def call(feed)
    feedjira_feed = fetch_and_parse(feed.url)
    feed.assign_attributes(
      title: feedjira_feed.title,
      website_url: feedjira_feed.url
    )

    feed_items = feedjira_feed.entries.each do |feedjira_entry|
      guid = feedjira_entry.entry_id || feedjira_entry.url

      feed.items.where(guid: guid).first_or_initialize do |item|
        item.title = feedjira_entry.title
        item.url = feedjira_entry.url
        item.published_at = feedjira_entry.published
      end
    end

    new_items_count = feed_items.size { |item| !item.persisted? }
    Rails.logger.info("FetchFeedService: Fetched #{new_items_count} new items from feed=#{feed.id}")

    feed.assign_attributes(
      errored_at: nil,
      error_message: nil
    )
  rescue StandardError => e
    if feed.errored_at.nil?
      feed.errored_at = Time.current
      feed.error_message = e.message
    end
  ensure
    feed.fetched_at = Time.current
    feed
  end

  private

  def fetch_and_parse(url)
    connection = Faraday.new(url: url, headers: {}, request: { timeout: 10 }) do |conn|
      conn.use FaradayMiddleware::FollowRedirects, limit: 6
      conn.adapter(*Faraday.default_adapter)
    end
    response = connection.get(url)

    raise "Fetch failed - #{response.status}" unless response.success?

    Feedjira.parse(response.body)
  end
end
