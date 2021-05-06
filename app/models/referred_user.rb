class ReferredUser < ActiveRecord::Base
  belongs_to :campaign

  scope :token,    -> (token) { where token: token }
  scope :email,    -> (email) { where email: email }

  has_secure_token
  validates :email, email_format: { message: "Invalid Email Address" }
  validates :campaign_id, uniqueness: {scope: :email}
  validates :campaign_id, uniqueness: {scope: :token}

  belongs_to :referrer, class_name: 'ReferredUser'
  has_many :referred, class_name: 'ReferredUser', foreign_key: :referred_user_id, dependent: :destroy
  has_many :milestone_award

  def ip_address
    self[:ip_address].blank? ? ';' : self[:ip_address]
  end

  def referral_url
    "#{campaign.url}/?salescamp=#{token}"
  end

  def twitter_share_url
    uri = URI('https://twitter.com/intent/tweet')
    uri.query = URI.encode_www_form([["url", referral_url], ["text", "Hey! Sign up to this awesome site here: "]])
    uri
  end

  def facebook_share_url
    uri = URI('http://www.facebook.com/sharer.php')
    uri.query = URI.encode_www_form([["s", 100], ["p[title]", "Sign up Here"], ["p[summary]","Hey! Sign up to this awesome site here: "],["p[url]",referral_url],["p[redirect_uri]","https://developers.facebook.com/tools/explorer"]])
    uri
  end

  def is_awarded(milestone)
    milestone = self.milestone_award.find_by_milestone_id(milestone.id)
    if milestone
      return milestone.awarded
    else
      return false
    end
  end

  def can_be_awarded(milestone)
    # if self.referred.count >= milestone.referral_count
    if self.referrals >= milestone.referral_count
      milestone = MilestoneAward.find_by_milestone_id(milestone.id)
      if milestone
        return milestone.awarded
      else
        return true
      end
    else
      return false
    end
  end

  def as_json(options = { })
    super((options || { }).merge({
      methods: [:referred_count]
    }))
  end

  def referred_count
    self.referred.count
  end

  def is_peding_reward(campaign)
    # if self.referred.count >= campaign.milestones.first.referral_count
    if self.referrals >= campaign.milestones.first.referral_count
      return true
    else
      return false
    end
  end

  def join_date
    created_at.strftime('%d %b %Y')
  end
end
