class CreateReminderMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :reminder_messages do |t|
      t.references :reminder, null: false, foreign_key: { on_delete: :cascade }
      t.integer :kind, null: false
      t.datetime :opened_at

      t.timestamps
    end
  end
end
