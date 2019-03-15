require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  background { visit question_path(question) }

  scenario 'Unauthenticated can not edit answer' do
    create(:answer, question: question, author: user)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'edits his answer', js: true do
      answer = create(:answer, question: question, author: user)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      answer = create(:answer, question: question, author: user)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer" do
      given (:other_user) { create(:user) }
      create(:answer, question: question, author: other_user)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
