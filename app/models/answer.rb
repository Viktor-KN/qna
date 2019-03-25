class Answer < ApplicationRecord
  default_scope { order(best: :desc, id: :asc) }

  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  def assign_as_best!
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update(best: true)
    end
  end
end
