# frozen_string_literal: true

FactoryBot.define do
  factory :reminder do
    user

    sequence :feed_url do |n|
      "https://website-#{n}.com/feed"
    end

    confirmed_at { Time.zone.now }

    transient do
      feed_title { nil }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :with_feed do
      after(:create) do |reminder, evaluator|
        feed_attr = { reminders: [reminder] }
        feed_attr[:title] = evaluator.feed_title unless evaluator.feed_title.nil?

        create(:feed, :with_items, **feed_attr)
      end
    end
  end
end
