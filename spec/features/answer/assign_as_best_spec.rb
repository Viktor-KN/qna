require 'rails_helper'

feature 'User can mark one answer as best', %q{
  In order to mark answer as correct solution
  As an author of question
  I'd like ot be able to mark one answer as best
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Unauthenticated user can not mark answer as best' do
    visit question_path(question)

    expect(page).to_not have_link 'Make best'
  end

  describe 'Authenticated user' do

    describe 'as question author' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'can mark one answer as best', js: true do
        first_answer, second_answer = answers

        within ".answer-#{second_answer.id}" do
          click_on 'Make best'

          expect(page).to_not have_link 'Make best'
        end

        within ".answers" do
          expect(page).to have_css '.best-answer', count: 1
          expect(second_answer.body).to appear_before(first_answer.body)
        end
      end

      scenario 'can mark another answer as best', js: true do
        first_answer, second_answer = answers

        within ".answer-#{second_answer.id}" do
          click_on 'Make best'
        end

        within ".answer-#{first_answer.id}" do
          click_on 'Make best'
          expect(page).to_not have_link 'Make best'
        end

        within ".answers" do
          expect(page).to have_css '.best-answer', count: 1
          expect(first_answer.body).to appear_before(second_answer.body)
        end
      end
    end

    describe 'as not question author' do
      given(:another_user) { create(:user) }

      background do
        sign_in(another_user)
        visit question_path(question)
      end

      scenario 'can not mark any answer as best', js: true do
        expect(page).to_not have_link 'Make best'
      end
    end
  end
end
