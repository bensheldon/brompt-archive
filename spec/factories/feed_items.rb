# frozen_string_literal: true

FactoryBot.define do
  factory :feed_item do
    feed
    sequence :title do |n|
      "Feed Item#{n}"
    end
    url { "#{feed.website_url}/#{title.parameterize}" }
    guid { url }
    sequence :published_at do |n|
      n.days.ago
    end
  end
end
