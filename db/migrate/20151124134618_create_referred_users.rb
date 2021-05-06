class CreateReferredUsers < ActiveRecord::Migration
  def change
    create_table :referred_users do |t|
      t.references :campaign, index: true, foreign_key: true, null: false
      t.string :email, null: false
      t.integer :referrer
      t.string :token, null: false

      t.timestamps null: false
    end
  end
end
