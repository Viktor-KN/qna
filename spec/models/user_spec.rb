require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    it { should have_many(:questions).with_foreign_key('author_id').dependent(:nullify) }
    it { should have_many(:answers).with_foreign_key('author_id').dependent(:nullify) }
    it { should have_many(:rewards).with_foreign_key('recipient_id').dependent(:nullify) }
    it { should have_many(:votes).dependent(:nullify) }
  end

  describe 'Validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'Methods' do
    describe '#author_of?' do
      let(:user) { create(:user) }
      let(:another_user) { create(:user) }
      let(:question) { create(:question, author: user) }
      let(:other_question) { create(:question, author: another_user) }

      it 'returns true on own question' do
        expect(user).to be_author_of(question)
      end

      it "returns false on somebody's question" do
        expect(user).to_not be_author_of(other_question)
      end
    end
  end
end
