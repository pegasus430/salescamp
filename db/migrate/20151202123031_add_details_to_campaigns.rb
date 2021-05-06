class AddDetailsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :title, :string
    add_column :campaigns, :subtitle, :string
    add_column :campaigns, :color, :string
  end
end
