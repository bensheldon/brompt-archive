class AllowNullEmailOnUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :email, :string, default: nil
  end
end
