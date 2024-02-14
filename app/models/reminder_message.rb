# frozen_string_literal: true
# == Schema Information
#
# Table name: reminder_messages
#
#  id            :bigint(8)        not null, primary key
#  reminder_id   :bigint(8)        not null
#  type          :integer          not null
#  opened_at     :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  uuid          :uuid             not null
#  delivered_at  :datetime
#  clicked_at    :datetime
#  complained_at :datetime
#
# Indexes
#
#  index_reminder_messages_on_reminder_id  (reminder_id)
#
# Foreign Keys
#
#  fk_rails_...  (reminder_id => reminders.id) ON DELETE => cascade
#

class ReminderMessage < ApplicationRecord
  self.inheritance_column = :inheritance_type

  enum type: { reminder: 0, repeat_reminder: 1 }, _suffix: true
  belongs_to :reminder

  alias_attribute :sent_at, :created_at
end
