require 'rails_helper'

feature 'User can delete own question', %q{
  In order to manage own questions
  As an authenticated user
  I'd like to be able to delete own question
} do

  given(:question) { create(:question) }

  background { visit question_path(question) }

  scenario 'user tries to delete own question' do
    click_on 'Delete question'

    expect(page).to have_content 'Question successfully deleted'
  end
end
