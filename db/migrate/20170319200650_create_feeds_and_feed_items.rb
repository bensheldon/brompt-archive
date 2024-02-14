class CreateFeedsAndFeedItems < ActiveRecord::Migration[5.0]
  def change
    create_table :feeds do |t|
      t.string :url, null: false
      t.string :title
      t.string :website_url
      t.datetime :fetched_at
      t.integer :reminders_count

      t.timestamps

      t.index :url, unique: true
    end

    create_table :feed_items do |t|
      t.references :feed, null: false, foreign_key: { on_delete: :cascade }
      t.string :guid, null: false
      t.string :title
      t.string :url
      t.datetime :published_at

      t.timestamps

      t.index [:feed_id, :guid], unique: true
    end

    change_table :reminders do |t|
      t.references :feed, null: false, foreign_key: { on_delete: :restrict }
    end
  end
end
