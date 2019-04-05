require 'rails_helper'

feature 'User can view list of his rewards', %q{
  In order to receive satisfaction for my best answers
  As an authenticated user
  I'd like to be able to see a list of rewards, received by me
} do
  given(:user) { create(:user) }
  given!(:rewards) { create_list(:reward, 3, image: png, recipient: user) }

  background { sign_in(user) }

  scenario 'visits rewards page and see list of his rewards' do
    visit rewards_path

    rewards.each do |reward|
      expect(page).to have_content reward.title
      expect(page).to have_content reward.question.title
      expect(page).to have_css("img[src*='#{png_name}']")
    end
  end
end
