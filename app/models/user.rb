class User < ActiveRecord::Base
  include Stripe::Callbacks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :campaigns
  has_one  :subscription, dependent: :destroy

  enum role: [:user, :admin]

  after_customer_updated! do |customer, event|
    subscription = Subscription.find_by_stripe_customer_token(customer.id)
    user = subscription.user

    user = User.find_by_stripe_customer_id(customer.id)
    if customer.delinquent
      user.active = false
      user.save!
    end
  end

  after_charge_succeeded do |charge|
    subscription = Subscription.find_by_stripe_customer_token(customer.id)
    user = subscription.user

    user = User.find_by_stripe_customer_id(customer.id)
    if user
      user.total_spent += amount
      user.payment_count += 1
      user.save!
    end
  end
end
