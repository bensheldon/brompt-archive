# frozen_string_literal: true
# == Schema Information
#
# Table name: feed_items
#
#  id           :bigint(8)        not null, primary key
#  feed_id      :bigint(8)        not null
#  guid         :string           not null
#  title        :string
#  url          :string
#  published_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_feed_items_on_feed_id           (feed_id)
#  index_feed_items_on_feed_id_and_guid  (feed_id,guid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (feed_id => feeds.id) ON DELETE => cascade
#

class FeedItem < ApplicationRecord
  belongs_to :feed, touch: true
  scope :published_at_ordered, -> { order published_at: :desc }
  scope :recent_by_feed, lambda { |count: 10|
    # This scope is complex. The table_reference (which is `feeds`) is aliased to be
    # the model's table (`feed_items`) so that when this scope is used as in an association
    # the eagerloaded foreign key query (`WHERE feed_items.feed_id` IN ...) will work properly.
    #
    # SELECT <columns>
    # FROM <table reference>
    #      JOIN LATERAL <subquery>
    #      ON TRUE;
    #
    query = select('subquery.*').from('(SELECT *, id AS feed_id FROM feeds) AS feed_items')

    join_sql = sanitize_sql_array([<<~SQL.squish, { count: count }])
      JOIN LATERAL (
        SELECT * FROM feed_items AS sub_feed_items
        WHERE sub_feed_items.feed_id = feed_items.feed_id
        ORDER BY published_at DESC
        LIMIT :count
      ) AS subquery ON TRUE
    SQL

    query.joins(join_sql)
  }
end
