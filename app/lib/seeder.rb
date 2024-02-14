# frozen_string_literal: true

class Seeder
  def seed
    create_admin
    create_users
  end

  def create_admin
    FactoryBot.create :user, email: 'admin@example.com', password: 'qwerty', is_admin: true
  end

  def create_users
    user = FactoryBot.create :user, email: 'user@example.com', password: 'qwerty'
    reminder = FactoryBot.create :reminder, :with_feed, user: user

    (1..10).each do |from|
      FactoryBot.create :feed_item, feed: reminder.feed, created_at: from.days.ago
    end
  end
end
