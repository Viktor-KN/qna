require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'Associations' do
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should belong_to :question}
    it { should belong_to(:author).class_name('User')}

    it 'have many attached files' do
      expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  it { should accept_nested_attributes_for :links }

  describe 'Validations' do
    it { should validate_presence_of :body }
  end

  describe 'Callbacks' do
    describe "#broadcast_new_answer" do
      it "is called after new record is created" do
        answer = build(:answer)

        expect(answer).to receive(:broadcast_new_answer)
        answer.save!
      end
    end
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

      it 'makes answer as best and saves changes to database' do
        first_answer.reload

        expect(first_answer).to be_best
      end
    end
  end

  describe 'default scope sorting' do
    let(:question) { create(:question) }
    let!(:first_answer) { create(:answer, question: question) }
    let!(:second_answer) { create(:answer, question: question, best: true) }
    let!(:third_answer) { create(:answer, question: question) }

    it 'best answer comes first' do
      expect(question.answers.first).to eq second_answer
    end

    it 'first answer comes before third answer' do
      expect(question.answers[1..2]).to eq [first_answer, third_answer]
    end
  end
end
