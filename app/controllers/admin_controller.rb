class AdminController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :authenticate_user!  

  layout 'admin'

  def index
    unless current_user.admin?
      redirect_to root_path
    end
    @companies = User.user.order({ created_at: :desc }).paginate(:page => params[:page], :per_page => 10)
    # smart_listing_create :companies, @companies, partial: "user/listing", default_sort: {created_at: "desc"}
  end

  def reset_password
    if current_user.admin?
      user_id = params[:user_id]
      user = User.find_by_id(user_id)
      user.send_reset_password_instructions
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end
end
