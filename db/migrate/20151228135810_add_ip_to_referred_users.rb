class AddIpToReferredUsers < ActiveRecord::Migration
  def change
    add_column :referred_users, :ip_address, :string
  end
end
