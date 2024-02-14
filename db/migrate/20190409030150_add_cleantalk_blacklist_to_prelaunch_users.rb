class AddCleantalkBlacklistToPrelaunchUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :prelaunch_users do |t|
      t.boolean :cleantalk_blacklist
    end
  end
end
