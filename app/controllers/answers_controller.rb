class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'Answer successfully created'
    else
      render 'questions/show'
    end
  end

  def destroy
    if @answer.can_delete?(current_user)
      @answer.destroy
      flash[:notice] = 'Answer successfully deleted'
    else
      flash[:alert] = "You don't have permission to do that"
    end

    redirect_to question_path(@answer.question)
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
