require 'rails_helper'

feature 'User can delete own answer', %q{
  In order to manage own answers
  As an authenticated user
  I'd like to be able to delete own answer
} do

  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: another_user) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    scenario 'tries to delete own answer' do
      create(:answer, author: user, question: question)

      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_content 'Answer successfully deleted'
    end

    scenario "tries to delete somebody’s answer" do
      create(:answer, author: another_user, question: question)

      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario "tries to delete somebody’s answer" do
      create(:answer, author: another_user, question: question)

      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end
end
