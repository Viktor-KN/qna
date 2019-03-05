require 'rails_helper'

feature 'User can ask a question', %q{
  In order to get help
  As an user
  I'd like to be able to ask a question
} do


  scenario 'user tries to ask a question with filled form' do
    question = attributes_for(:question)

    visit new_question_path
    fill_in 'Title', with: question[:title]
    fill_in 'Body', with: question[:body]
    click_on 'Create Question'

    expect(page).to have_content 'Question successfully created'
    expect(page).to have_content question[:title]
    expect(page).to have_content question[:body]
  end

  scenario 'user tries to ask a question with blank form' do
    visit new_question_path
    click_on 'Create Question'

    expect(page).to have_content "Title can't be blank"
  end
end
