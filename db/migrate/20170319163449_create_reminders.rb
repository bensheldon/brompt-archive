class CreateReminders < ActiveRecord::Migration[5.0]
  def change
    create_table :reminders do |t|
      t.string :id_token, null: false, unique: true
      t.string :email, null: false
      t.string :feed_url, null: false
      t.integer :remind_after_days, null: false
      t.integer :repeat_remind_after_days

      # Email confirmation
      t.string :confirmation_token
      t.datetime :confirmation_sent_at
      t.datetime :confirmed_at
      t.string :unconfirmed_email

      t.timestamps
    end
  end
end
