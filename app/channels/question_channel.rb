class QuestionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "new_question_events"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
