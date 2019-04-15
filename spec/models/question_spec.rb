require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'Associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_one(:reward).dependent(:destroy) }
    it { should belong_to(:author).class_name('User')}

    it 'have many attached files' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'Validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  describe 'Methods' do
    describe '#assign_reward!' do
      let(:user) { create(:user) }
      let(:question) { create(:question) }
      let!(:reward) { create(:reward, question: question, image: png) }

      it 'should assign attached to question reward to user' do
        question.assign_reward!(user)

        expect(reward.recipient).to eq user
      end
    end
  end
end
