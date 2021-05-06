class CreateMilestoneAwards < ActiveRecord::Migration
  def change
    create_table :milestone_awards do |t|
      t.references :referred_user, index: true, null: false
      t.references :milestone, index: true, null: false
      t.boolean :awarded, default: false

      t.timestamps null: false
    end
  end
end
