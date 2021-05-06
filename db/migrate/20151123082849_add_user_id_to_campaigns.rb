class AddUserIdToCampaigns < ActiveRecord::Migration
  def change
    add_reference :campaigns, :user, index: true, foreign_key: true
  end
end
