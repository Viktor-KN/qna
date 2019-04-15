module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[vote_up vote_down vote_delete]
  end

  def vote_up
    do_vote(1)
  end

  def vote_down
    do_vote(-1)
  end

  def vote_delete
    vote = @votable.votes.find_by(user: current_user)

    if vote.present?
      vote.destroy

      render json: { id: @votable.id,
                     type: js_model_name,
                     renderedVoteUpControl: render_control('vote_up', 0),
                     renderedVoteDownControl: render_control('vote_down', 0),
                     score: @votable.vote_score,
                     message: "Successfully deleted vote for this #{human_model_name}" }
    else
      render json: { message: "You don't have vote on this #{human_model_name}" },
             status: :not_found
    end
  end

  private

  def do_vote(result)
    return render_not_allowed if current_user.author_of?(@votable)

    vote = @votable.votes.find_by(user: current_user)

    if vote.present?
      render json: { message: "Already have #{vote.up? ? 'up' : 'down'} vote on this #{human_model_name}" },
             status: :conflict
    else
      @votable.votes.create(user: current_user, result: result)

      render json: { id: @votable.id,
                     type: js_model_name,
                     renderedVoteUpControl: render_control('vote_up', result),
                     renderedVoteDownControl: render_control('vote_down', result),
                     score: @votable.vote_score,
                     message: "Successfully voted #{result == 1 ? 'up' : 'down'} for this #{human_model_name}" }
    end
  end

  def render_not_allowed
    render json: { message: "You are not allowed to vote for own #{human_model_name}" }, status: :forbidden
  end

  def render_control(action, result)
    view_context.vote_control(@votable, action, result, action == 'vote_up' ? 'triangle-up' : 'triangle-down')
  end

  def model_klass
    controller_name.classify.constantize
  end

  def human_model_name
    @votable.model_name.human.downcase
  end

  def js_model_name
    @votable.model_name.to_s.underscore.dasherize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end
end
