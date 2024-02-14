class CreatePrelaunchUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :prelaunch_users do |t|
      t.timestamps
      t.string :email, null: false
      t.string :first_name
    end
  end
end
