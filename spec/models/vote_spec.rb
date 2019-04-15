require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:votable) }
  end

  describe 'Validations' do
    subject { create(:vote) }
    it { should validate_uniqueness_of(:user_id).scoped_to([:votable_type, :votable_id]) }
    it { should validate_inclusion_of(:result).in_array([1, -1]) }
  end

  describe 'Methods' do
    let(:vote) { Vote.new }

    describe '#up?' do
      it 'returns true on result = 1' do
        vote.result = 1

        expect(vote.up?).to be_truthy
      end
      it 'returns false on any other result' do
        vote.result = -1

        expect(vote.up?).to be_falsey
      end
    end

    describe '#down?' do
      it 'returns true on result = -1' do
        vote.result = -1

        expect(vote.down?).to be_truthy
      end
      it 'returns false on any other result' do
        vote.result = 1

        expect(vote.down?).to be_falsey
      end
    end
  end
end
