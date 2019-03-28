require 'rails_helper'

feature 'User can ask a question', %q{
  In order to get help
  As an authenticated user
  I'd like to be able to ask a question
} do


  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'tries to ask a question with filled form' do
      question = attributes_for(:question)

      fill_in 'Title', with: question[:title]
      fill_in 'Body', with: question[:body]
      click_on 'Create Question'

      expect(page).to have_content 'Question successfully created'
      expect(page).to have_content question[:title]
      expect(page).to have_content question[:body]
    end

    scenario 'tries to ask a question with blank form' do
      click_on 'Create Question'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'tries to ask a question with attached files' do
      question = attributes_for(:question)

      fill_in 'Title', with: question[:title]
      fill_in 'Body', with: question[:body]

      attach_file 'Files', [test_assets_path(png_name), test_assets_path(zip_name)]
      click_on 'Create Question'

      expect(page).to have_content 'Question successfully created'
      expect(page).to have_link png_name
      expect(page).to have_link zip_name
    end
  end

  scenario 'Unauthenticated user tries to ask question' do
    visit questions_path
    click_on 'New question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
