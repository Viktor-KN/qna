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

      attach_file :question_files, [test_assets_path(png_name), test_assets_path(zip_name)]
      click_on 'Create Question'

      expect(page).to have_content 'Question successfully created'
      expect(page).to have_link png_name
      expect(page).to have_link zip_name
    end

    scenario 'tries to ask a question with attached links', js: true do
      question = attributes_for(:question)
      simple_link = attributes_for(:link)
      gist_link = attributes_for(:link, :gist)

      fill_in 'Title', with: question[:title]
      fill_in 'Body', with: question[:body]

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

      click_on 'Create Question'

      expect(page).to have_content 'Question successfully created'
      expect(page).to have_link simple_link[:name]
      expect(page).to have_link gist_link[:name]
      expect(page).to have_content 'gist-test-1.txt'
      expect(page).to have_content 'gist_test_1'
      expect(page).to have_content 'gist-test-2.txt'
      expect(page).to have_content 'gist_test_2'
    end

    scenario 'tries to ask a question with partially filled link fields', js: true do
      question = attributes_for(:question)
      simple_link = attributes_for(:link)

      fill_in 'Title', with: question[:title]
      fill_in 'Body', with: question[:body]

      click_on 'Add link'
      within '#links .nested-fields:last-of-type' do
        fill_in 'Name', with: simple_link[:name]
      end

      click_on 'Create Question'

      expect(page).to_not have_content 'Question successfully created'
      expect(page).to_not have_link simple_link[:name]
      expect(page).to have_content "Links url can't be blank"
      expect(page).to have_content "Links url is an invalid URL"
    end

    scenario 'tries to ask a question with reward', js: true do
      question = attributes_for(:question)

      fill_in 'Title', with: question[:title]
      fill_in 'Body', with: question[:body]

      within '#reward' do
        click_on 'Add reward'

        fill_in 'Title', with: 'Reward title'
        attach_file 'Image', test_assets_path(png_name)
      end

      click_on 'Create Question'

      expect(page).to have_content 'Question successfully created'
      expect(page).to have_css '.reward'
    end

    scenario 'tries to ask a question with partially filled reward fields', js: true do
      question = attributes_for(:question)

      fill_in 'Title', with: question[:title]
      fill_in 'Body', with: question[:body]

      within '#reward' do
        click_on 'Add reward'

        fill_in 'Title', with: 'Reward title'
      end

      click_on 'Create Question'

      expect(page).to_not have_content 'Question successfully created'
      expect(page).to have_content 'Reward image must be attached'
      expect(page).to have_css '#question_reward_attributes_title'
      expect(page).to have_css '#question_reward_attributes_image'
    end
  end

  scenario 'Unauthenticated user tries to ask question' do
    visit questions_path
    click_on 'New question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
