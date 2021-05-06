require 'rails_helper'

RSpec.describe User, type: :model do
  it "should have a valid factory" do
    expect(FactoryGirl.build(:user).valid?).to be_truthy
  end
end
