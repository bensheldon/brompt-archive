# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string
#  encrypted_password     :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  first_name             :string
#  reminders_count        :integer          default(0), not null
#  upgrade_info_at        :datetime
#  is_admin               :boolean          default(FALSE), not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :confirmable, :trackable

  attr_accessor :allow_nil_email

  class << self
    Devise::Models.config(self, :email_regexp, :password_length)
  end

  has_many :reminders, dependent: :destroy

  # Implement validatable manually
  validates :email, presence: true, unless: :allow_nil_email
  validates :email, uniqueness: { allow_blank: true, message: ->(user, _e) { user.email_taken_message }, if: :will_save_change_to_email? }
  validates :email, format: { with: email_regexp, allow_blank: true, if: :will_save_change_to_email? }

  validates :password, presence: { if: :password_required? }
  validates :password, presence: true, on: :welcome_password
  validates :password, confirmation: { if: :password_required? }
  validates :password, length: { within: password_length, allow_blank: true }

  validates :first_name, presence: true, on: :edit_first_name

  def email_taken_message
    url_helpers = Rails.application.routes.url_helpers
    existing_user = User.find_by(email: email)

    if existing_user.confirmed? && existing_user.password_present?
      "already exists. <a href=\"#{url_helpers.new_user_session_path(sign_out: true, email: email)}\">Sign in</a> to continue."
    elsif existing_user.confirmed?
      "already exists. <a href=\"#{url_helpers.new_user_password_path(sign_out: true, email: email)}}\">Reset your password</a> to continue."
    else
      "already exists. <a href=\"#{url_helpers.new_user_confirmation_path(sign_out: true, email: email)}\">Confirm your email</a> to continue."
    end
  end

  def password_present?
    encrypted_password.present? || !password.nil?
  end

  def reminders_count_limit
    2 # TODO: logic based on payment
  end

  def can_create_reminders?
    reminders_count < reminders_count_limit
  end

  private

  def confirmation_period_valid?
    true
  end

  def password_required?
    !password.nil? || !password_confirmation.nil?
  end

  def send_confirmation_notification?
    false
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
