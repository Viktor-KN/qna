class Comment < ApplicationRecord
  default_scope { order(:id) }

  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  after_commit :broadcast_new_comment, on: :create

  private

  def broadcast_new_comment
    BroadcastObjectCreationJob
      .perform_later("new_comment_events_for_#{commentable_type.downcase}_#{self.commentable_id}", comment: self)
  end
end
