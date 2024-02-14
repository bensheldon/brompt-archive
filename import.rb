# frozen_string_literal: true

#
# Imports old reminders from Brompt version 1
#
require 'csv'

all_minders = CSV.open('/Users/bensheldon/Dropbox/Brompt/v1 database exports/minder.csv', headers: true).to_a
all_sent_minders = CSV.open('/Users/bensheldon/Dropbox/Brompt/v1 database exports/minder_sent.csv', headers: true).to_a
grouped_all_sent_minders = all_sent_minders.group_by { |ms| ms['mid'].to_i }

all_minders.each do |minder|
  next if minder['confirmed'].blank? || minder['confirmed'].to_i.zero?

  reminder = Reminder.find_or_initialize_by(id_token: minder['unique_string'])
  class << reminder
    def record_timestamps
      false
    end
  end

  reminder.update(
    id_token: minder['unique_string'],
    email: minder['email'],
    feed_url: minder['feed_url'],
    remind_after_days: minder['remind_days'],
    repeat_remind_after_days: minder['interval_days'],
    confirmed_at: Time.zone.at(minder['confirmed'].to_i),
    created_at: Time.zone.at(minder['modified'].to_i),
    updated_at: DateTime.current
  )

  sent_minders = grouped_all_sent_minders[minder['mid'].to_i]
  puts "importing #{sent_minders.count} message for reminder #{reminder.id}"

  reminder.messages.destroy_all unless sent_minders.empty?
  reminder_messages = sent_minders.map do |sent_minder|
    sent_at = Time.zone.at(sent_minder['timestamp'].to_i)

    ReminderMessage.new(
      reminder: reminder,
      type: :reminder,
      created_at: sent_at
    )
  end

  ReminderMessage.import reminder_messages
end
