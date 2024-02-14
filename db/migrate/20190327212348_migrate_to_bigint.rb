class MigrateToBigint < ActiveRecord::Migration[5.2]
  def change
    change_column :feed_items, :id, :bigint
    change_column :feed_items, :feed_id, :bigint

    change_column :feeds, :id, :bigint

    change_column :prelaunch_users, :id, :bigint

    change_column :reminder_messages, :id, :bigint
    change_column :reminder_messages, :reminder_id, :bigint

    change_column :reminders, :id, :bigint
    change_column :reminders, :feed_id, :bigint
  end
end
