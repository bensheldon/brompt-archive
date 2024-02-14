class LoosenContactRequirementsForReminders < ActiveRecord::Migration[5.2]
  def change
    change_table :reminders do |t|
      t.change :email, :string, null: true
      t.change :remind_after_days, :integer, null: true
      t.change :feed_id, :integer, null: true
    end
  end
end
