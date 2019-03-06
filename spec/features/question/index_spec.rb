require 'rails_helper'

feature 'User can view list of questions', %q{
  In order to find answers or to help another
  As an user
  I'd like to be able to see a list of questions
} do

  scenario 'user visits questions page and see list of questions' do
    questions = create_list(:question, 3)

    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end
