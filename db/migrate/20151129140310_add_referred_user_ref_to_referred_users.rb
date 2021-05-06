class AddReferredUserRefToReferredUsers < ActiveRecord::Migration
  def change
    remove_column :referred_users, :referrer
    add_reference :referred_users, :referred_user, index: true, foreign_key: true
  end
end
