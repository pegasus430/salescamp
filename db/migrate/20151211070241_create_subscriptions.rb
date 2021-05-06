class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :plan_id, null: false
      t.string :subscription_id, null: false
      t.string :stripe_customer_token, null: false
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
