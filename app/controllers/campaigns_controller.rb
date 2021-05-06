class CampaignsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  layout 'application-hero', only: [:step_one, :step_two, :new, :edit, :create, :update]
  before_action :authenticate_user!, except: [:step_one, :step_two, :confirmation, :check_subscription]
  before_filter :auth_user, except: [:step_one, :check_subscription]

  def index
    @campaigns = current_user.campaigns

    @campaigns_total_referrals = current_user.campaigns.map{ |camp| camp.referred_users.map{ |user| user.referrals}.sum }.sum
    @campaigns_joined_campaign_count = current_user.campaigns.map{ |camp| camp.referred_users.count }.sum

    @campaigns_pending_rewards = current_user.campaigns.map{ |camp| camp.referred_users.where("fullfilled < ?", camp.milestones.count).select{|u| u.is_peding_reward(camp)}.count }.sum

    @campaigns_referrals_today = current_user.campaigns.map{ |camp| camp.referred_users.where("created_at >= ? AND referred_user_id IS NOT NULL", Time.zone.now.beginning_of_day).size }.sum
       
  end

  def show
    @campaign = Campaign.find(params[:id])

    plan_id = if current_user.subscription.nil?
                # @limit = 0
                # Stripe::Plans::BASIC
              else
                current_user.subscription.plan_id
              end

    #plan_id = current_user.subscription.plan_id
    @referred_users = @campaign.referred_users

    if current_user.subscription && current_user.subscription.plan_id
      @limit = 500
    elsif ((Time.now - current_user.created_at)/86400) < 8
      @limit = 30000
    else
      @limit = 0
    end
    
    

    case plan_id.to_s
    when Stripe::Plans::BASIC.to_s
      @more_than_plan = @referred_users.count > 500
      @referred_users = @campaign.referred_users.limit(500)
      @limit = 500
    when Stripe::Plans::ADVANCED.to_s
      @more_than_plan = @referred_users.count > 5000
      @referred_users = @campaign.referred_users.limit(5000)
      @limit = 5000
    when Stripe::Plans::PROFESSIONAL.to_s
      @more_than_plan = @referred_users.count > 15000
      @referred_users = @campaign.referred_users.limit(15000)
      @limit = 15000
    when Stripe::Plans::BUSINESS.to_s
      @more_than_plan = @referred_users.count > 30000
      @referred_users = @campaign.referred_users.limit(30000)
      @limit = 30000
    end

    # @total_referrals = @campaign.referred_users.where.not(referred_user_id: nil).count
    @total_referrals = @campaign.referred_users.map{ |user| user.referrals}.sum

    @joined_campaign_count = @campaign.referred_users.count

    @referrals_today = @campaign.referred_users.where("created_at >= ? AND referred_user_id IS NOT NULL", Time.zone.now.beginning_of_day).size

    # smart_listing_create :referred_users, @referred_users.where(fullfilled: false), partial: "referred_users/listing", default_sort: {created_at: "desc"}, sort_dirs: ["asc", "desc"]
    # @campaign_info = @referred_users.where(fullfilled: false).order(created_at: "desc").paginate(:page => params[:page], :per_page => 10)
    @campaign_info = @referred_users.order(created_at: "desc").paginate(:page => params[:page], :per_page => 10)
    
    if !@campaign.user or @campaign.user.id != current_user.id
      raise "not owned error"
    end
    @current_user = current_user

    @pending_rewards = @referred_users.where("fullfilled < ?", @campaign.milestones.count).select{|u| u.is_peding_reward(@campaign)}.count
    @pending_rewards_list = @referred_users.where("fullfilled < ?", @campaign.milestones.count).select{|u| u.is_peding_reward(@campaign)}

   
    @fullfilled_rewards = @referred_users.where("fullfilled >= ?", 1)

    respond_to do |format|
      format.html
      format.csv { send_data @campaign.to_csv, :filename => @campaign.name + ".csv" }
      format.js
    end
  end

  def code_snippet
    @campaign = Campaign.find(params[:id])
  end

  def step_one
  end

  def step_two
    @type = request[:type]

    if @type != 'pre' and @type != 'established'
      redirect_to step_one_new_campaign_path
    end
    @campaign = Campaign.get_campaign_class(request[:type]).new
  end

  def new
    step = params[:steps_campaign]
    if (!step or !step.has_key?(:type) or !step.has_key?(:name) or !step.has_key?(:url))
      redirect_to step_one_new_campaign_path
      return
    end
    if (step[:type] != 'pre' and step[:type] != 'established')
      redirect_to step_one_new_campaign_path
      return
    end

    @_type = step[:type]
    @campaign = Campaign.get_campaign_class(step[:type]).new(user:current_user, name: step[:name], url: "#{step[:url_protocol]}#{step[:url]}")
    @campaign.milestones.build(referral_count:0)
    @type = @campaign.type

    @referred_user = ReferredUser.new(campaign:@campaign)
  end

  def create
    begin
      @campaign = current_user.campaigns.create(campaign_params)
      if @campaign.save
        flash[:success] = "Created a new campaign"
        redirect_to code_snippet_campaign_path(:id=>@campaign.id)
      else
        @referred_user = ReferredUser.new(campaign:@campaign)
        render "new"
      end
    rescue ActiveRecord::StatementInvalid => e
      flash[:alert] = "Check your rewards once, Campaign not saved!"
      redirect_to :back
    end
  end

  def edit
    @campaign = Campaign.find(params[:id])
    @referred_user = ReferredUser.new(campaign:@campaign)
  end

  def update
    @campaign = Campaign.find(params[:id])
    if @campaign.update_attributes(campaign_params)
      # Handle a successful update.
      @campaign.save
      flash[:success] = "If you updated the campaign color, you will need to update your code snippet on your existing pages."
      redirect_to code_snippet_campaign_path(:id=>@campaign.id)
    else
      @referred_user = ReferredUser.new(campaign:@campaign)
      render 'edit'
    end
  end

  def destroy
    @campaign = Campaign.find(params[:id])
    if @campaign.user_id == current_user.id
      flash[:success] = "Campaign Deleted Successfully"
      @campaign.destroy
    end
    redirect_to campaigns_path
  end

  def fullfilled_rewards
    params[:ids].each do |user|
      @user = ReferredUser.find(user)
      # @user.update_attribute(:fullfilled, true)
      @user.increment!(:fullfilled)
    end
    @user_ids = params[:ids]
    @campaign = Campaign.find(params[:id])
    plan_id = if current_user.subscription.nil?
                Stripe::Plans::BASIC
              else
                current_user.subscription.plan_id
              end

    # @limit = 500
    # case plan_id.to_s
    # when Stripe::Plans::BASIC.to_s
    #   @limit = 500
    # when Stripe::Plans::ADVANCED.to_s
    #   @limit = 5000
    # when Stripe::Plans::PROFESSIONAL.to_s
    #   @limit = 15000
    # when Stripe::Plans::BUSINESS.to_s
    #   @limit = 30000
    # end
    #@fullfilled_rewards = @campaign.referred_users.where(:fullfilled => true).limit(@limit).count
    @fullfilled_rewards = @campaign.referred_users.where('fullfilled >= 1').count
    #@pending_rewards_list = @campaign.referred_users.where(:fullfilled => false).limit(@limit).select{|u| u.is_peding_reward(@campaign)}
    @pending_rewards_list = @campaign.referred_users.where("fullfilled < ?", @campaign.milestones.count).select{|u| u.is_peding_reward(@campaign)}
    @pending_rewards_count = @pending_rewards_list.count
    respond_to do |format|
      format.js 
    end
  end

  def check_subscription
    @campaign = Campaign.find(params[:campaign_id])

    if @campaign.user.subscription.nil? && (((Time.now - @campaign.user.created_at)/86400) > 8)
      subscription_plan = {:status => false}
    else
      subscription_plan = {:status => true}
    end
    render :json => subscription_plan
  end

  private

  def campaign_params
    if (params[:campaign])
      required_params = params.require(:campaign)
    elsif (params[:pre_campaign])
      required_params =  params.require(:pre_campaign)
    else (params[:established_campaign])
      required_params =  params.require(:established_campaign)
    end
    required_params.permit(:name, :title, :subtitle, :type, :url, :color, milestones_attributes:[:id,:caption,:referral_count, :_destroy])
  end

  def auth_user
    redirect_to new_user_registration_url unless user_signed_in?
  end
end
