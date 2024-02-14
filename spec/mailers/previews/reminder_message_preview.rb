# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/confirmation
class ReminderMessagePreview < ActionMailer::Preview
  def reminder
    reminder = FactoryBot.create(:reminder, :with_feed)
    reminder_message = FactoryBot.build(:reminder_message, reminder: reminder)
    ReminderMessageMailer.reminder(reminder_message)
  end

  def repeat_reminder
    reminder = FactoryBot.create(:reminder, :with_feed)
    reminder_message = FactoryBot.build(:reminder_message, reminder: reminder, type: :repeat_reminder)
    ReminderMessageMailer.reminder(reminder_message)
  end
end
