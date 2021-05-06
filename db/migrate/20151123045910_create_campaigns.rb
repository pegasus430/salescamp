class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name, null: false
      t.string :url, null: false, default: ""
      t.string :type, null: false

      t.timestamps null: false
    end
  end
end
