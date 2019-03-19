require 'rails_helper'

feature 'User can delete own question', %q{
  In order to manage own questions
  As an authenticated user
  I'd like to be able to delete own question
} do

  given(:another_user) { create(:user) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    scenario 'tries to delete own question' do
      question = create(:question, author: user)

      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Question successfully deleted'
      expect(page).to_not have_link question.title
    end

    scenario "tries to delete somebody’s question" do
      question = create(:question, author: another_user)

      visit question_path(question)

      expect(page).to_not have_link 'Delete'
    end
  end

  describe 'Unauthenticated user' do
    scenario "tries to delete somebody’s question" do
      question = create(:question, author: another_user)

      visit question_path(question)

      expect(page).to_not have_link 'Delete'
    end
  end
end
