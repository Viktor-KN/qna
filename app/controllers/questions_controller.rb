class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy]
  before_action :find_question, only: %i[show destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to question_path(@question), notice: 'Question successfully created'
    else
      render :new
    end
  end

  def destroy
    if @question.can_delete?(current_user)
      @question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted'
    else
      redirect_to question_path(@question), alert: "You don't have permission to do that"
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
