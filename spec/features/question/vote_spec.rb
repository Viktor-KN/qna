require 'rails_helper'

feature 'User can vote for a question', %q{
  In order to state the value
  As an authenticated user
  I'd like to be able to vote for a question of other users
} do
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    before { sign_in(user) }

    scenario "tries to vote up for other user's question", js: true do
      visit question_path(question)

      within '.question .vote' do
        click_on 'Vote up'

        within '.vote-score' do
          expect(page).to have_content '1'
        end

        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
        expect(page).to have_link 'Cancel vote'
      end

      expect(page).to have_content 'Successfully voted up for this question'
    end

    scenario "tries to vote down for other user's question", js: true do
      visit question_path(question)

      within '.question .vote' do
        click_on 'Vote down'

        within '.vote-score' do
          expect(page).to have_content '-1'
        end

        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
        expect(page).to have_link 'Cancel vote'
      end

      expect(page).to have_content 'Successfully voted down for this question'
    end

    scenario "tries to cancel own vote for other user's question", js: true do
      create(:vote, votable: question, user: user, result: 1)

      visit question_path(question)

      within '.question .vote' do
        click_on 'Cancel vote'

        within '.vote-score' do
          expect(page).to have_content '0'
        end

        expect(page).to have_link 'Vote up'
        expect(page).to have_link 'Vote down'
        expect(page).to_not have_link 'Cancel vote'
      end

      expect(page).to have_content 'Successfully deleted vote for this question'
    end

    scenario "tries to vote for own question", js: true do
      question = create(:question, author: user)

      visit question_path(question)

      within '.question .vote' do
        within '.vote-score' do
          expect(page).to have_content '0'
        end

        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
        expect(page).to_not have_link 'Cancel vote'
      end
    end
  end

  scenario 'Unauthenticated user tries to vote for a question', js: true do
    visit question_path(question)

    within '.question .vote' do
      within '.vote-score' do
        expect(page).to have_content '0'
      end

      expect(page).to_not have_link 'Vote up'
      expect(page).to_not have_link 'Vote down'
      expect(page).to_not have_link 'Cancel vote'
    end
  end
end
