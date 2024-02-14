class AddUpgradeInfoAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :upgrade_info_at, :datetime
  end
end
