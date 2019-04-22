class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_one :reward, dependent: :destroy

  belongs_to :author, class_name: 'User'

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_commit :broadcast_new_question, on: :create

  def assign_reward!(user)
    reward.update!(recipient: user) if reward
  end

  private

  def broadcast_new_question
    BroadcastObjectCreationJob.perform_later("new_question_events", question: self)
  end
end
