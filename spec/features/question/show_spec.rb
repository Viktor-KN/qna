require 'rails_helper'

feature 'User can view question and answers to it', %q{
  In order to find help or help other users
  As an user
  I'd like to be able to see a question and answers
} do

  scenario 'user visits question show page and see question and answers to it' do
    question = create(:question_with_answers)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each { |answer| expect(page).to have_content answer.body }
  end
end
