class AddGoodJobIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :good_jobs, :scheduled_at
    add_index :good_jobs, [:queue_name, :scheduled_at]
  end
end
