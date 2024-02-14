# frozen_string_literal: true
# == Schema Information
#
# Table name: feeds
#
#  id              :bigint(8)        not null, primary key
#  url             :string           not null
#  title           :string
#  website_url     :string
#  fetched_at      :datetime
#  reminders_count :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  errored_at      :datetime
#  error_message   :string
#
# Indexes
#
#  index_feeds_on_url  (url) UNIQUE
#

class Feed < ApplicationRecord
  has_many :items, class_name: 'FeedItem' # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :reminders # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :recent_items, -> { recent_by_feed(count: 10) }, class_name: 'FeedItem', inverse_of: :feed # rubocop:disable Rails/HasManyOrHasOneDependent
  has_one :latest_item, -> { recent_by_feed(count: 1) }, class_name: 'FeedItem', inverse_of: :feed # rubocop:disable Rails/HasManyOrHasOneDependent

  scope :has_reminders, -> { where Feed.arel_table[:reminders_count].gt(0) }
  scope :fetch_ready, -> { where Feed.arel_table[:fetched_at].lt(7.hours.ago).or Feed.arel_table[:fetched_at].eq(nil) }

  def latest_item_published_at
    latest_item&.published_at
  end
end
