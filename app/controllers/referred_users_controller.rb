class ReferredUsersController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  layout 'confirmation'
  protect_from_forgery :except => :create 
  before_action :set_campaign
  after_action :set_header

  def index
  end

  def new
    @token = request[:token]
    @email = request[:email]

    @referred_user = @campaign.referred_users.build(email: @email, token: @token)

    render 'confirmation'
  end

  def create
    user = @campaign.referred_users.email(referred_user_params[:email]).first


    if user
      @result = true
      @referred_user = user
      respond_to do |format|
        format.html { render 'confirmation' }
        format.js
      end
      return
    end


    referrer = @campaign.referred_users.token(referred_user_params[:token]).first

    @referred_user = if referrer.blank?
      @campaign.referred_users.new
    else
      referrer.referred.new
    end

    if @campaign.referred_users.where(ip_address: request.remote_ip).count >= 3
      respond_to do |format|
        format.html { render 'too_many_requests' }
        format.js
      end

      # render json: { message: 'TooManyRequests' }, status: 401
      return
    end

    @referred_user.email       = referred_user_params[:email]
    @referred_user.ip_address  = request.remote_ip
    @referred_user.campaign_id = @campaign.id

    @result = @referred_user.save


    if @result

      unless referrer.blank?
        # referrer.update_attribute(:referrals, referrer.referred.count)
        #referrer.update_attribute(:referrals, referrer.referrals + 1)
        #faster but less reliable. by how much, idk yet
        ReferralMailer.got_referral_email(referrer,@referred_user).deliver_later
      end

      # send mail to the signed up user

      ReferralMailer.welcome_email(@referred_user).deliver_later

      respond_to do |format|
        format.html { render 'confirmation' }
        format.js
      end
    else
      @errors = @referred_user.errors
      respond_to do |format|
        format.html { render 'confirmation' }
        format.js
      end
    end
  end

  def show
    @referred_user = @campaign.referred_users.find(params[:id])

    render 'confirmation'
  end

  def destroy_multiple
    ids = params[:ids].split(",")
    @referred_users = ReferredUser.where(id: ids)
    @referred_users.each do |r|
      referrer = r.referred_user_id
      unless referrer.nil?
        referrer = ReferredUser.find(referrer)
        referrer.update_attribute(:referrals, referrer.referred.count)
      end
      r.destroy
    end
    plan_id = if current_user.subscription.nil?
                Stripe::Plans::BASIC
              else
                current_user.subscription.plan_id
              end

    @limit = 500
    case plan_id.to_s
    when Stripe::Plans::BASIC.to_s
      @limit = 500
    when Stripe::Plans::ADVANCED.to_s
      @limit = 5000
    when Stripe::Plans::PROFESSIONAL.to_s
      @limit = 15000
    when Stripe::Plans::BUSINESS.to_s
      @limit = 30000
    end

    @fullfilled_rewards = @campaign.referred_users.where("fullfilled >= ?", 1).count
    @pending_rewards_list = @campaign.referred_users.where("fullfilled < ?", @campaign.milestones.count).select{|u| u.is_peding_reward(@campaign)}
    @pending_rewards_count = @pending_rewards_list.count
    respond_to do |format|
      format.js
    end
  end

  def confirmation
    @campaign = Campaign.find(params[:id])
    @referred_user = @campaign.referred_users.email(params[:email]).first
    if @referred_user.blank?
      @referred_user = @campaign.referred_users.new
    end
  end

  def refer_increment

      referrer = @campaign.referred_users.token(params[:token]).first

      referrer.increment!(:referrals)

      render plain: "icremented"
  end

  private

  def email_referrer(referred)
    referrer = ReferredUser.find_by_id(referred.referred_user_id)
    unless referrer.blank?
      referrer_email = referrer.email
      referred_email = referred.email
      ModelMailer.new_referral_notification(referrer_email, referred_email).deliver
    end
  end

  def referred_user_params
    params.require(:referred_user).permit(:email, :token)
  end

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
  
  def set_header
    response.headers.except! 'X-Frame-Options'
  end
end
