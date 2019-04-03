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

    scenario 'edits his question by attaching files', js: true do
      visit question_path(question)

      within ".question" do
        click_on 'Edit'
        attach_file :question_files, [test_assets_path(png_name), test_assets_path(zip_name)]
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_link png_name
        expect(page).to have_link zip_name
      end

      expect(page).to have_content 'Question successfully updated'
    end

    scenario 'edits his question by attaching links', js: true do
      simple_link = attributes_for(:link)
      gist_link = attributes_for(:link, :gist)

      visit question_path(question)

      within ".question" do
        click_on 'Edit'

        click_on 'Add link'
        within '#links .nested-fields:last-of-type' do
          fill_in 'Name', with: simple_link[:name]
          fill_in 'Url', with: simple_link[:url]
        end

        click_on 'Add link'
        within '#links .nested-fields:last-of-type' do
          fill_in 'Name', with: gist_link[:name]
          fill_in 'Url', with: gist_link[:url]
        end

        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_link simple_link[:name]
        expect(page).to have_link gist_link[:name]
        expect(page).to have_content 'gist-test-1.txt'
        expect(page).to have_content 'gist_test_1'
        expect(page).to have_content 'gist-test-2.txt'
        expect(page).to have_content 'gist_test_2'
      end

      expect(page).to have_content 'Question successfully updated'
    end

    scenario 'edits his question with errors', js: true do
      simple_link = attributes_for(:link)

      visit question_path(question)

      within ".question" do
        click_on 'Edit'
        fill_in 'Title', with: ''
        fill_in 'Your question', with: ''

        click_on 'Add link'
        within '#links .nested-fields:last-of-type' do
          fill_in 'Name', with: simple_link[:name]
        end

        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to_not have_link simple_link[:name]
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content "Links url can't be blank"
        expect(page).to have_content "Links url is an invalid URL"
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
