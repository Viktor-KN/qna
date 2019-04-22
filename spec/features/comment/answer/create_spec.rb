require 'rails_helper'

feature 'User can write a comment for answer', %q{
  In order to discuss answer
  As an authenticated user
  I'd like to be able write comment for an answer
} do
  given(:commentable) { create(:answer) }
  given(:visit_path) { question_path(commentable.question) }

  include_examples 'comment creation'
end
