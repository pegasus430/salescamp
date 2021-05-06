class ReferralMailer < ApplicationMailer
	default from: "no-reply@salescamp.io"
  	layout 'mailer'

  	def welcome_email(referred_user)
  		@referred_user = referred_user
  		@campaign = Campaign.find(@referred_user.campaign_id)

	    mail(to: @referred_user.email, subject: 'You successfully joined a referral campaign')
	end

	def got_referral_email(referrer,referred_user)
		@referred_user = referred_user
		@campaign = Campaign.find(@referred_user.campaign_id)
		mail(to: referrer.email, subject: 'You referred someone!')
	end

	def campaign_daily_report(campaign_user,no_of_signedups)
		@no_of_signedups = no_of_signedups
		mail(to: campaign_user.email, subject: 'Daily report of your Salescamp campaign')
	end
end
