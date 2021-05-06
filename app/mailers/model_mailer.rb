class ModelMailer < ApplicationMailer

  default from: 'no-reply@salescamp.io'

  layout 'mailer'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.new_referral_notification.subject
  #
  def new_referral_notification(referrer, referred)
    @greeting = "Hello"

    @referred = referred
    mail to: referrer, subject: "You referred someone!"
  end
end
