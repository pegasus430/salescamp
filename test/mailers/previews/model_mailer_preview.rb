# Preview all emails at http://localhost:3000/rails/mailers/model_mailer
class ModelMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/model_mailer/new_referral_notification
  def new_referral_notification
    ModelMailer.new_referral_notification
  end

end
