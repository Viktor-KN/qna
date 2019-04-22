class CommentChannel < ApplicationCable::Channel
  def subscribed
    stream_from "new_comment_events_for_#{params[:commentable_type]}_#{params[:commentable_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
