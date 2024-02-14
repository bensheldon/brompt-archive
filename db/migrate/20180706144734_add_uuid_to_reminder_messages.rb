class AddUuidToReminderMessages < ActiveRecord::Migration[5.1]
  def change
    enable_extension "pgcrypto"
    add_column :reminder_messages, :uuid, :uuid, default: -> { "gen_random_uuid()" }
    change_column_null :reminder_messages, :uuid, false
  end
end
