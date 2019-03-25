require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'Associations' do
    it { should belong_to :question}
    it { should belong_to(:author).class_name('User')}
  end

  describe 'Validations' do
    it { should validate_presence_of :body }
  end

  describe 'Methods' do
    describe '#assign_as_best!' do
      let(:question) { create(:question) }
      let!(:first_answer) { create(:answer, question: question) }
      let!(:second_answer) { create(:answer, question: question, best: true) }

      before { first_answer.assign_as_best! }

      it 'makes all other answers not best' do
        second_answer.reload

        expect(second_answer).to_not be_best
      end

      it 'makes answer as best' do
        expect(first_answer).to be_best
      end

      it 'saves changes to database' do
        first_answer.reload

        expect(first_answer).to be_best
      end
    end
  end
end
