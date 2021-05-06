class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.string :caption
      t.integer :referral_count

      t.timestamps null: false
    end
  end
end
