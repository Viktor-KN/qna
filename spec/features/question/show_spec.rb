require 'rails_helper'

feature 'User can view question and answers to it', %q{
  In order to find help or help other users
  As an user
  I'd like to be able to see a question and answers
} do

  scenario 'user visits question show page and see question and answers to it' do
    question = create(:question_with_answers, :with_files, with_answer_files: true)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    within '.question' do
      expect(page).to have_link png_name
      expect(page).to have_link txt_name
      expect(page).to have_link zip_name
    end

    question.answers.each do |answer|
      within ".answer-#{answer.id}" do
        expect(page).to have_content answer.body
        expect(page).to have_link png_name
        expect(page).to have_link txt_name
        expect(page).to have_link zip_name
      end
    end
  end

  scenario 'user visits question show page and see links in question and answer', js: true do
    question = create(:question)
    answer = create(:answer, question: question)
    question_link = create(:link, :gist, linkable: question)
    answer_link = create(:link, :gist, linkable: answer)

    visit question_path(question)

    within '.question' do
      expect(page).to have_link question_link.name
      expect(page).to have_content 'gist-test-1.txt'
      expect(page).to have_content 'gist_test_1'
      expect(page).to have_content 'gist-test-2.txt'
      expect(page).to have_content 'gist_test_2'
    end

    within ".answers" do
      expect(page).to have_link answer_link.name
      expect(page).to have_content 'gist-test-1.txt'
      expect(page).to have_content 'gist_test_1'
      expect(page).to have_content 'gist-test-2.txt'
      expect(page).to have_content 'gist_test_2'
    end
  end
end
