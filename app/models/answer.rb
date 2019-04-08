class Answer < ApplicationRecord
  default_scope { order(best: :desc, id: :asc) }

  has_many :links, dependent: :destroy, as: :linkable

  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def assign_as_best!
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.assign_reward!(author)
    end
  end
end
