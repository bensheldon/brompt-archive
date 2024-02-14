# frozen_string_literal: true
# == Schema Information
#
# Table name: reminders
#
#  id                       :bigint(8)        not null, primary key
#  id_token                 :string           not null
#  email                    :string
#  feed_url                 :string           not null
#  remind_after_days        :integer
#  repeat_remind_after_days :integer
#  confirmation_token       :string
#  confirmation_sent_at     :datetime
#  confirmed_at             :datetime
#  unconfirmed_email        :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  feed_id                  :bigint(8)
#  user_id                  :bigint(8)
#
# Indexes
#
#  index_reminders_on_feed_id  (feed_id)
#  index_reminders_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (feed_id => feeds.id) ON DELETE => restrict
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#

class Reminder < ApplicationRecord
  REMIND_AFTER_DAYS = {
    1 => '1 day',
    2 => '2 days',
    5 => '5 days',
    7 => '1 week',
    14 => '2 weeks',
    30 => '1 month',
    60 => '2 months',
    90 => '3 months',
    180 => '6 months',
  }.freeze

  REPEAT_REMIND_AFTER_DAYS = {
    1 => 'Every day',
    2 => 'Every 2 days',
    5 => 'Every 5 days',
    7 => 'Every week',
    14 => 'Every 2 weeks',
    30 => 'Every month',
    60 => 'Every 2 months',
    90 => 'Every 3 months',
    180 => 'Every 6 months',
  }.freeze

  attribute :remind_after_days, :integer, default: 7
  attribute :repeat_remind_after_days, :integer, default: 7

  auto_strip_attributes :feed_url

  before_validation :set_feed, on: [:create, :update], if: :feed_url_changed?

  belongs_to :feed, counter_cache: true
  belongs_to :user, optional: true, counter_cache: true
  has_many :messages, class_name: 'ReminderMessage', dependent: :destroy
  has_one :latest_message, -> { order created_at: :desc }, class_name: 'ReminderMessage', inverse_of: :reminder # rubocop:disable Rails/HasManyOrHasOneDependent

  has_secure_token :id_token
  has_secure_token :confirmation_token

  scope :confirmed, -> { joins(:user).where.not(users: { confirmed_at: nil }) }

  validate :below_user_reminders_limit, on: [:create]
  validates :feed_url, presence: true

  def to_param
    id_token
  end

  def email
    raise "Migrate Reminder#email to User#email"
  end

  def confirmed_at
    raise 'Migrate Reminder#confirmed_at to User#confirmed_at'
  end

  def email=(new_email)
    return if email == new_email

    if email.present? && confirmed_at.present?
      self.unconfirmed_email = new_email
      self.confirmed_at = nil
    else
      self[:email] = new_email
    end
  end

  def latest_message_sent_at
    latest_message&.sent_at
  end

  private

  def set_feed
    return if feed.present? && feed.url == feed_url

    self.feed = Feed.where(url: feed_url).first_or_initialize
  end

  def below_user_reminders_limit
    errors.add(:base, "You cannot create more reminders.") if user && !user.can_create_reminders?
  end
end
