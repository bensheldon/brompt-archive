class AddEventsToReminderMessages < ActiveRecord::Migration[5.1]
  def change
    change_table :reminder_messages do |t|
      t.datetime :delivered_at
      t.datetime :clicked_at
      t.datetime :complained_at
    end
  end
end
