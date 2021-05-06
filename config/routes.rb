Rails.application.routes.draw do

  # match "*path" => redirect("https://salescamp.io/%{path}"), :constraints => { :protocol => "http://" }
  
  get 'refer_increment/:campaign_id/:token' => 'referred_users#refer_increment'

  get 'campaigns/:campaign_id/check_subscription/' => 'campaigns#check_subscription'

  devise_for :users
  root 'static#index'
  get 'frequently-asked-questions' => 'static#faq'
  get 'contact-us' => 'static#contact_us'
  post 'submit-contact-form' => 'static#submit_contact_form'
  get 'terms' => 'static#terms'

  get 'admin' => 'admin#index', as: :admin
  post 'admin_reset' => 'admin#reset_password', as: :admin_reset_pass
  get 'settings' => 'user#settings', as: :settings
  post 'subscription_checkout' => 'user#subscription_checkout'
  get 'subscription_cancel' => 'user#subscription_cancel'
  post 'milestones/award_milestone' => 'milestones#award_milestone'



  resources :campaigns do
    get :step_one, on: :new
    get :step_two, on: :new
    member do
      get :code_snippet
      post :fullfilled_rewards
    end
    resources :milestones
    resources :referred_users do
      post :destroy_multiple, as: :destroy_multiple, on: :collection
      member do
        get :confirmation
      end
    end
  end

end
