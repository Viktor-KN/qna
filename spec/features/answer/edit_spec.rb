require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario 'Unauthenticated can not edit answer' do
    create(:answer, question: question, author: user)

    visit question_path(question)

    within ".answers" do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'edits his answer', js: true do
      answer = create(:answer, question: question, author: user)

      visit question_path(question)

      within ".answers" do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end

      expect(page).to have_content 'Answer successfully updated'
    end

    scenario 'edits his answer by attaching files', js: true do
      answer = create(:answer, question: question, author: user)

      visit question_path(question)

      within ".answers" do
        click_on 'Edit'
        attach_file 'Files', [test_assets_path(png_name), test_assets_path(zip_name)]
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_link png_name
        expect(page).to have_link zip_name
      end

      expect(page).to have_content 'Answer successfully updated'
    end

    scenario 'edits his answer with errors', js: true do
      answer = create(:answer, question: question, author: user)

      visit question_path(question)

      within ".answers" do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer" do
      other_user = create(:user)
      create(:answer, question: question, author: other_user)

      visit question_path(question)

      within ".answers" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
