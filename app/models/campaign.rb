class Campaign < ActiveRecord::Base
  validates_format_of :url, :with => URI::regexp(%w(http https))
  validates :user_id, presence: true

  belongs_to :user
  has_many :milestones, dependent: :destroy
  has_many :referred_users, dependent: :destroy
  accepts_nested_attributes_for :milestones, reject_if: :all_blank, allow_destroy: true
  # def title
  #   super || "#{self.name}'s Campaign"
  # end

  def display_name
    ""
  end

  def type_i
    raise 'virtual method'
  end

  def self.get_campaign_class(type)
    if type == 'pre'
      PreCampaign
    elsif type == 'established'
      EstablishedCampaign
    end
  end

  def self.inherited(child)
    child.instance_eval do
      def model_name
        Campaign.model_name
      end
    end
    super
  end

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv.add_row ["Email", "Join Date", "IP Address", "Referrals", "Rewards Earned"]
      self.referred_users.order('created_at DESC').each do |user|
        rewards =  self.milestones.select{|m| user.can_be_awarded(m)}.count
        rewards == 0 ? rewards_earned = 0 : rewards_earned = "(#{rewards} pending)"
        values = user.slice(:email, :join_date, :ip_address, :referrals).values
        values << rewards_earned
        csv.add_row values
      end
    end
  end

end
