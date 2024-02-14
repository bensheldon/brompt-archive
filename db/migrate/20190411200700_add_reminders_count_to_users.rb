class AddRemindersCountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :reminders_count, :integer, default: 0, null: false

    reversible do |direction|
      direction.up do
        User.reset_column_information
        User.find_each do |user|
          User.reset_counters user.id, :reminders
        end
      end
    end
  end
end
