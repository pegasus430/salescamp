FactoryGirl.define do
  factory :user do
    email
    password "password"
  end
  sequence :email do |n|
    "person#{n}@salescamp.io"
  end
end
