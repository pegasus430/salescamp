require 'rails_helper'

RSpec.feature "Campaigns", type: :feature do
  it "sign up process" do
    visit '/'
    click_link "Register"
    within('.signup-form-wrapper') do
      fill_in 'user[email]', :with => 'hardik.patel@meesabzi.com'
      fill_in 'user[password]', :with => '12345678'
      fill_in 'user[password_confirmation]', :with => '12345678'
      click_button 'REGISTER'
    end
  end
  describe "Add Another Reward" do
    it 'should add a new reward on clicking add new reward button' do
      user = FactoryGirl.create(:user)
      visit '/'
      click_link 'LOGIN'
      within('.overlay-form-wrapper') do
        fill_in 'user[email]', :with => user.email
        fill_in 'user[password]',:with => 'password'
        click_button 'Login'
      end
      click_link 'Create a Campaign'
      expect(find('.header')).to have_content('Select campaign type')
      all('.campaign-type-div').first.click_link('Select Campaign Type')
      expect(find('.header')).to have_content('Pre-launch campaign information')
      within('.basicinformation') do
        fill_in 'steps_campaign[name]', :with => "Testing Campaign"
        fill_in 'steps_campaign[url]', :with => "http://salescamp.io"
        click_button 'Next Step'
      end
      expect(find('.header')).to have_content('Create your campaign')
      within('.create-campaign-div') do
        fill_in 'campaign[color]', :with => "#823939"
      end
      input_count = all('input').count
      click_link '+ Add Another Reward'
      expect(all('input').count).to be(input_count+1)
    end
  end
end
