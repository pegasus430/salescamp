class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :int, null: false, default: "user"
  end
end
