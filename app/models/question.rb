class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true

  def can_delete?(user)
    author == user
  end
end
