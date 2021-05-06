class StaticController < ApplicationController
  layout 'application-hero', only: [:faq,:contact_us,:terms]

  def index
    if user_signed_in?
      if current_user.admin?
        redirect_to admin_path
      else
        redirect_to campaigns_path
      end
    end
  end

  def faq
    
  end

  def contact_us
    
  end

  def submit_contact_form    
    ContactMailer.send_contact_mail(request).deliver
    flash[:success] = "Your message has been sent!"
    redirect_to contact_us_path
  end

  def terms
    
  end
end
