class AddCampaignIdToMilestones < ActiveRecord::Migration
  def change
    add_reference :milestones, :campaign, index: true, foreign_key: true
  end
end
