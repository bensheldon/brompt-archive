# frozen_string_literal: true

FactoryBot.define do
  factory :feed do
    sequence :title do |n|
      "Feed Number #{n}"
    end

    website_url { "https://#{title.parameterize}.com/blog" }
    url { "#{website_url}/feed" }
    fetched_at { Time.current }

    trait :with_items do
      transient do
        items_count { 3 }
      end

      after(:create) do |feed, evaluator|
        create_list(:feed_item, evaluator.items_count, feed: feed)
      end
    end
  end
end
