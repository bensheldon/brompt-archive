class AddErrorsToFeeds < ActiveRecord::Migration[5.1]
  def change
    change_table :feeds do |t|
      t.datetime :errored_at
      t.string :error_message
    end
  end
end
