class Milestone < ActiveRecord::Base
  validates :referral_count, numericality: { greater_than_or_equal_to: 1}
  validates_uniqueness_of :campaign_id, :scope => [:referral_count]

  belongs_to :campaign

  default_scope { order('referral_count') }

  def <=> other
    self.referral_count <=> other.referral_count
  end
end
