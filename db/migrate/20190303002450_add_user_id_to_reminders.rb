class AddUserIdToReminders < ActiveRecord::Migration[5.2]
  def change
    add_reference :reminders, :user, index: true, foreign_key: { on_delete: :cascade }
  end
end
