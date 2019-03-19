require 'rails_helper'

feature 'User can delete own answer', %q{
  In order to manage own answers
  As an authenticated user
  I'd like to be able to delete own answer
} do

  given(:other_user) { create(:user) }
  given(:question) { create(:question, author: other_user) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    scenario 'tries to delete own answer', js: true do
      answer = create(:answer, author: user, question: question)

      visit question_path(question)
      within ".answers" do
        accept_confirm do
          click_on 'Delete'
        end
      end

      expect(page).to have_content 'Answer successfully deleted'
      expect(page).to_not have_content answer.body
    end

    scenario "tries to delete other user’s answer" do
      create(:answer, author: other_user, question: question)

      visit question_path(question)

      within ".answers" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario "tries to delete other user’s answer" do
      create(:answer, author: other_user, question: question)

      visit question_path(question)

      within ".answers" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end
