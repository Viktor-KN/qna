require 'rails_helper'

feature 'User can write an answer for question', %q{
  In order to provide help
  As an user
  I'd like to be able to write an answer for question
} do
  given(:question) { create(:question) }

  background { visit question_path(question) }

  scenario 'user tries to write an answer for question with filled form' do
    answer = attributes_for(:answer)

    fill_in 'Body', with: answer[:body]
    click_on 'Create Answer'

    expect(page).to have_content 'Answer successfully created'
    expect(page).to have_content answer[:body]
  end

  scenario 'user tries to write an answer for question with blank form' do
    click_on 'Create Answer'

    expect(page).to have_content "Body can't be blank"
  end
end
