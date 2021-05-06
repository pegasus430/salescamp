class MilestoneAward < ActiveRecord::Base
  belongs_to :referred_user
  belongs_to :milestone
end
