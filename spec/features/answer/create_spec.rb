require 'rails_helper'

feature 'User can write an answer for question', %q{
  In order to provide help
  As an authenticated user
  I'd like to be able to write an answer for question
} do
  given(:question) { create(:question) }


  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to write an answer for question with filled form', js: true do
      answer = attributes_for(:answer)

      fill_in 'New answer', with: answer[:body]
      click_on 'Create Answer'

      within '.answers' do
        expect(page).to have_content answer[:body]
      end

      expect(page).to have_content 'Answer successfully created'
    end

    scenario 'tries to write an answer for question with blank form', js: true do
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to write an answer with attached files', js: true do
      answer = attributes_for(:answer)

      fill_in 'New answer', with: answer[:body]

      attach_file 'Files', [test_assets_path(png_name), test_assets_path(zip_name)]
      click_on 'Create Answer'

      within '.answers' do
        expect(page).to have_content answer[:body]
        expect(page).to have_link png_name
        expect(page).to have_link zip_name
      end

      expect(page).to have_content 'Answer successfully created'
    end
  end

  scenario 'Unauthenticated user tries to write an answer' do
    visit question_path(question)

    expect(page).to_not have_field 'answer_body'
    expect(page).to_not have_button 'Create Answer'
  end
end
