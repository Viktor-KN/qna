require 'rails_helper'

feature 'User can delete own answer', %q{
  In order to manage own answers
  As an authenticated user
  I'd like to be able to delete own answer
} do

  given(:question) { create(:question_with_answers) }

  background { visit question_path(question) }

  scenario 'user tries to delete own question' do
    click_on 'Delete answer'

    expect(page).to have_content 'Answer successfully deleted'
  end
end
