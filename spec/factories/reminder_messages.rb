# frozen_string_literal: true

FactoryBot.define do
  factory :reminder_message do
    reminder
    type { :reminder }
    uuid { SecureRandom.uuid }
  end
end
