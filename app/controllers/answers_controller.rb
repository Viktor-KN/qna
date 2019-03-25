class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy assign_as_best]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy assign_as_best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    if @answer.save
      flash.now.notice = 'Answer successfully created'
    end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash.now.notice = 'Answer successfully updated'
    else
      flash.now.alert = "You don't have permission to do that"
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now.notice = 'Answer successfully deleted'
    else
      flash.now.alert = "You don't have permission to do that"
    end
  end

  def assign_as_best
    if current_user.author_of?(@answer.question)
      @answer.assign_as_best!
      flash.now.notice = 'Answer successfully made best'
    else
      flash.now.alert = "You don't have permission to do that"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
