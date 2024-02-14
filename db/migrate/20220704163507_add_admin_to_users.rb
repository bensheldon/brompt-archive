class AddAdminToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_admin, :boolean, default: false
    change_column_null :users, :is_admin, false
  end
end
