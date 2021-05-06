class AddIndexToReferredUsers < ActiveRecord::Migration
  def change
    add_index :referred_users, [:campaign_id, :email], unique: true
    add_index :referred_users, [:campaign_id, :token], unique: true
  end
end
