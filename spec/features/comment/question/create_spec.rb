require 'rails_helper'

feature 'User can write a comment for question', %q{
  In order to discuss question
  As an authenticated user
  I'd like to be able write comment for a question
} do
  given(:commentable) { create(:question) }
  given(:visit_path) { question_path(commentable) }

  include_examples 'comment creation'
end
