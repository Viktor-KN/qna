require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    within ".question" do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'edits his question', js: true do
      visit question_path(question)

      within ".question" do
        click_on 'Edit'
        fill_in 'Title', with: 'edited title'
        fill_in 'Your question', with: 'edited question'
        click_on 'Save'
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'input'
        expect(page).to_not have_selector 'textarea'
      end

      expect(page).to have_content 'Question successfully updated'
    end

    scenario 'edits his question with errors', js: true do
      visit question_path(question)

      within ".question" do
        click_on 'Edit'
        fill_in 'Title', with: ''
        fill_in 'Your question', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question" do
      other_user = create(:user)
      other_question = create(:question, author: other_user)

      visit question_path(other_question)

      within ".question" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
