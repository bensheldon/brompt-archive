# frozen_string_literal: true

class FeedStat
  attr_reader :feed

  def initialize(input_feed)
    @feed = input_feed
  end

  def item_durations
    recent_items.each_cons(2).map { |a, b| (b.published_at - a.published_at).abs }
  end

  def average_item_duration
    durations = item_durations
    durations.sum.to_f / durations.size
  end

  def last_item
    recent_items.first
  end

  def recent_items
    return @_recent_items if defined? @_recent_items

    @_recent_items = if feed.persisted?
                       @feed.recent_items
                     else
                       @feed.items.sort_by(&:published_at).reverse!
                     end
  end
end
