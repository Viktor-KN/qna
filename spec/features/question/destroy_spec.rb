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

    scenario "tries to delete other user’s question" do
      question = create(:question, author: another_user)

      visit question_path(question)

      expect(page).to_not have_link 'Delete'
    end

    scenario 'tries to delete attached file in own question', js: true do
      question = create(:question, author: user, files: [png])

      visit question_path(question)

      within '.question-attached-files' do
        accept_confirm { click_on 'Delete' }

        expect(page).to_not have_link png_name
      end

      expect(page).to have_content 'File successfully deleted'
    end

    scenario 'tries to delete attached link in own question', js: true do
      question = create(:question, author: user)
      link = create(:link, linkable: question)

      visit question_path(question)

      within '.question-attached-links' do
        accept_confirm { click_on 'Delete' }

        expect(page).to_not have_link link.name
      end

      expect(page).to have_content 'Link successfully deleted'
    end

    scenario "tries to delete attached file in other user's question" do
      question = create(:question, author: another_user, files: [png])

      visit question_path(question)

      within '.question-attached-files' do
        expect(page).to have_link png_name
        expect(page).to_not have_link 'Delete'
      end
    end

    scenario "tries to delete attached link in other user's question" do
      question = create(:question, author: another_user)
      link = create(:link, linkable: question)

      visit question_path(question)

      within '.question-attached-links' do
        expect(page).to have_link link.name
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario "tries to delete other user’s question" do
      question = create(:question, author: another_user)

      visit question_path(question)

      expect(page).to_not have_link 'Delete'
    end

    scenario "tries to delete attached file in other user's question" do
      question = create(:question, author: another_user, files: [png])

      visit question_path(question)

      within '.question-attached-files' do
        expect(page).to have_link png_name
        expect(page).to_not have_link 'Delete'
      end
    end

    scenario "tries to delete attached link in other user's question" do
      question = create(:question, author: another_user)
      link = create(:link, linkable: question)

      visit question_path(question)

      within '.question-attached-links' do
        expect(page).to have_link link.name
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end
