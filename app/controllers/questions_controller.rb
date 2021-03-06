class QuestionsController < ApplicationController
  include Voted

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :find_question, only: %i[show update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    gon.push(question_id: @question.id, answers: @question.answers.ids, current_user: current_user ? current_user.id : 0)
  end

  def new
    @question = current_user.questions.new
    @question.build_reward
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to question_path(@question), notice: 'Question successfully created'
    else
      @question.build_reward unless @question.reward
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      flash.now.notice = 'Question successfully updated'
    else
      flash.now.alert = "You don't have permission to do that"
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted'
    else
      redirect_to question_path(@question), alert: "You don't have permission to do that"
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url],
                                     reward_attributes: [:title, :image])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
