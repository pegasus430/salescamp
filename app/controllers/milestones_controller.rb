class MilestonesController < ApplicationController
  before_action :set_campaign, except: [:award_milestone]
  
  def create
    @milestone = @campaign.milestones.build(milestone_params)
    if @milestone.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
      #flash[:success] = "Milestone Saved!"
      #redirect_to :back
    else
      flash[:alert] = "Check the milestone form, milestone not saved!"
      redirect_to :back
    end
  end

  def destroy
    @milestone = @campaign.milestones.find(params[:id])
    puts @milestone

    if @milestone.campaign.user_id == current_user.id
      @milestone.delete
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end

    #@milestone.destroy
    #flash[:success] = "Milestone removed"
    #redirect_to root_path
  end

  def award_milestone
    @milestone = Milestone.find(params[:milestone_id])

    if @milestone.campaign.user_id == current_user.id
      @award = MilestoneAward.new
      @award.referred_user = ReferredUser.find params[:referred_user_id]
      @award.milestone = @milestone
      @award.awarded = true

      respond_to do |format|
        if @award.save
          format.js
        else
          format.js
        end
      end
    end
  end

  private

  def milestone_params
    params.require(:milestone).permit(:caption, :referral_count)
  end

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
end
