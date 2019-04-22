class Answer < ApplicationRecord
  include Votable

  default_scope { order(best: :desc, id: :asc) }

  has_many :links, dependent: :destroy, as: :linkable

  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  after_commit :broadcast_new_answer, on: :create

  def assign_as_best!
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.assign_reward!(author)
    end
  end

  private

  def broadcast_new_answer
    BroadcastObjectCreationJob
      .perform_later("new_answer_events_for_question_#{self.question_id}", answer: ::AnswerSerializer.new(self).as_json)
  end
end
