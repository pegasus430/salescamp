class AddSpentAndPaymentsToUserTable < ActiveRecord::Migration
  def change
    add_column :users, :total_spent, :integer, default: 0
    add_column :users, :payment_count, :integer, default: 0
  end
end
