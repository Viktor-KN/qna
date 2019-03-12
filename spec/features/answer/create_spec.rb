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

    scenario 'tries to write an answer for question with filled form' do
      answer = attributes_for(:answer)

      fill_in 'Body', with: answer[:body]
      click_on 'Create Answer'

      expect(page).to have_content 'Answer successfully created'
      expect(page).to have_content answer[:body]
    end

    scenario 'tries to write an answer for question with blank form' do
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to write an answer' do
    visit question_path(question)

    expect(page).to_not have_field 'answer_body'
    expect(page).to_not have_button 'Create Answer'
  end
end
