class AddCampaignUniquenesToMilestone < ActiveRecord::Migration
  def change
    change_column_null :milestones, :campaign_id, false
  end
end
