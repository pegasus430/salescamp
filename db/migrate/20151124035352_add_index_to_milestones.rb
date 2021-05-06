class AddIndexToMilestones < ActiveRecord::Migration
  def change
    add_index :milestones, [:referral_count, :campaign_id], unique: true
  end
end
