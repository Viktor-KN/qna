module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_score
    votes.sum(:result)
  end

  def vote_result_for(user)
    vote = votes.find_by(user: user)

    vote.present? ? vote.result : 0
  end
end
