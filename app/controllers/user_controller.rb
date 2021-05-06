class UserController < ApplicationController
  before_action :authenticate_user!  
  helper_method :get_features

  def settings
    @plans = [Stripe::Plans::BASIC,
              Stripe::Plans::ADVANCED,
              Stripe::Plans::PROFESSIONAL,
              Stripe::Plans::BUSINESS]
    @user  = current_user

    @plans.each do |plan|
      if @user.subscription && plan.id == @user.subscription.plan_id.parameterize.underscore.to_sym
        @plan_name = plan.name
      end
    end

    if @user.subscription
      # @plan_name = @plan_name
    elsif @user.subscription.nil? && (((Time.now - current_user.created_at)/86400) < 8)
      @plan_name = 'Trial'
    else
      @plan_name = 'No'
    end
    
    render layout: "stripe"
  end

  def subscription_checkout
    if current_user.subscription.nil?

      customer = Stripe::Customer.create(
        source:         params[:stripeToken],
        email:          current_user.email,
      )

      plan = Stripe::Plan.retrieve(params[:plan_id])

      # Save this in your DB and associate with the user;s email
      stripe_subscription = customer.subscriptions.create(plan: plan.id)

      subscription = current_user.build_subscription
      subscription.plan_id               = plan.id
      subscription.subscription_id       = stripe_subscription.id
      subscription.stripe_customer_token = customer.id
      subscription.save
    else
      customer_id      = current_user.subscription.stripe_customer_token
      subscription_id = current_user.subscription.subscription_id

      customer = Stripe::Customer.retrieve(customer_id)
      stripe_subscription = customer.subscriptions.retrieve(subscription_id)
      stripe_subscription.plan = params[:plan_id]
      stripe_subscription.save

      subscription  = current_user.subscription
      subscription.plan_id = params[:plan_id]
      subscription.save
    end

    if subscription.save
      flash[:notice] = "Successfully updated subscription"
      redirect_to settings_path
    else
      flash[:warn] = "Sorry, but something went wrong!"
      redirect_to settings_path
    end
  end

  def get_features(plan)
    plan.metadata[:features].split(',')
  end

  def subscription_cancel
    customer_id      = current_user.subscription.stripe_customer_token
    user_subscription  = current_user.subscription
    subscription_id = user_subscription.subscription_id
    customer = Stripe::Customer.retrieve(customer_id)
    stripe_subscription = customer.subscriptions.retrieve(subscription_id)
    stripe_subscription.delete(:at_period_end => true)

    user_subscription.destroy

    redirect_to settings_path
  end
end
