# frozen_string_literal: true
# == Schema Information
#
# Table name: prelaunch_users
#
#  id                  :bigint(8)        not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  email               :string           not null
#  first_name          :string
#  cleantalk_blacklist :boolean
#

class PrelaunchUser < ApplicationRecord
  validates :email, presence: true
end
