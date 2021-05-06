# This file contains descriptions of all your stripe plans

# Example
# Stripe::Plans::PRIMO #=> 'primo'

# Stripe.plan :primo do |plan|
#
#   # plan name as it will appear on credit card statements
#   plan.name = 'Acme as a service PRIMO'
#
#   # amount in cents. This is 6.99
#   plan.amount = 699
#
#   # currency to use for the plan (default 'usd')
#   plan.currency = 'usd'
#
#   # interval must be either 'week', 'month' or 'year'
#   plan.interval = 'month'
#
#   # only bill once every three months (default 1)
#   plan.interval_count = 3
#
#   # number of days before charging customer's card (default 0)
#   plan.trial_period_days = 30
# end

# Once you have your plans defined, you can run
#
#   rake stripe:prepare
#
# This will export any new plans to stripe.com so that you can
# begin using them in your API calls.

Stripe.plan :basic do |plan|
  plan.name = 'Basic'
  plan.amount = 3200
  plan.metadata = { features: ['Unlimited Campaigns', '0-500', '0-500'].join(',') }
  plan.interval = 'month'
end

Stripe.plan :advanced do |plan|
  plan.name = 'Advanced'
  plan.amount = 12000
  plan.metadata = { features: ['Unlimited Campaigns', '501-5000', '501-5000'].join(',') }
  plan.interval = 'month'
end

Stripe.plan :professional do |plan|
  plan.name = 'Professional'
  plan.amount = 22000
  plan.metadata = { features: ['Unlimited Campaigns', '5001-15000', '5001-15000'].join(',') }
  plan.interval = 'month'
end

Stripe.plan :business do |plan|
  plan.name = 'Business Pro'
  plan.amount = 50000
  plan.metadata = { features: ['Unlimited Campaigns', '15001-30000', '15001-30000'].join(',') }
  plan.interval = 'month'
end
