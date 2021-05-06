class AddFullfilledToReferredUsers < ActiveRecord::Migration
  def change
    add_column :referred_users, :fullfilled, :integer,  :default => 0
  end
end
