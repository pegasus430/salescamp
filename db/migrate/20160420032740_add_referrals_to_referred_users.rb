class AddReferralsToReferredUsers < ActiveRecord::Migration
  def change
    add_column :referred_users, :referrals, :integer, default: 0
  end
end
