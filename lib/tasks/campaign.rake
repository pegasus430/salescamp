namespace :campaign do
  desc "TODO"

  task daily_report: :environment do

  	@campaigns = Campaign.all
	
  	@campaigns.each do |campaign|
  	  @campaign_user = campaign.user
  	  @no_of_signedups = campaign.referred_users.count
  	  ReferralMailer.campaign_daily_report(@campaign_user,@no_of_signedups).deliver_later
      
      ".. Mail sent of campaign <%= campaign.id %>..."
  	end
  end

end
