class ChangeIntForFullfilled < ActiveRecord::Migration
  def self.up
    change_table :referred_users do |t|
      t.change :fullfilled, :integer, :default => 0
    end
  end

  def self.down
    change_table :referred_users do |t|
      t.change :fullfilled, :boolean, :default => false
    end
  end

end
