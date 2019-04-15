require 'rails_helper'

RSpec.describe 'Votable', type: :model do
  with_model :WithVotable do
    model { include Votable }
  end

  describe 'Associations' do
    subject { WithVotable.create! }

    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'Methods' do
    let(:votable) { WithVotable.create! }

    describe '#vote_score' do
      it 'returns zero if no votes' do
        expect(votable.vote_score).to eq 0
      end

      it 'returns total sum of vote results on votable' do
        create_list(:vote, 3, votable: votable, result: 1)

        expect(votable.vote_score).to eq 3
      end
    end

    describe '#vote_result_for' do
      let!(:user) { create(:user) }

      it "returns zero if no user's vote found" do
        expect(votable.vote_result_for(user)).to eq 0
      end

      it "returns result of user's vote" do
        create(:vote, user: user, votable: votable, result: -1)

        expect(votable.vote_result_for(user)).to eq -1
      end
    end
  end
end
