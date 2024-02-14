# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { 'password' }

    sequence(:first_name) do |n|
      Faker::Config.random = Random.new(n)
      Faker::Name.first_name
    end

    confirmed_at { 1.day.ago }

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :blank do
      email { nil }
      password { nil }
      allow_nil_email { true }
    end
  end
end
