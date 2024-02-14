class CreateGoodJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :good_jobs, id: :uuid do |t|
      t.timestamps

      t.text :queue_name
      t.integer :priority
      t.jsonb :serialized_params
      t.timestamp :scheduled_at
    end
  end
end
