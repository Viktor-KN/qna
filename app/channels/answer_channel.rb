class AnswerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "new_answer_events_for_question_#{params[:question_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
