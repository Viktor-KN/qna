require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    it { should have_many(:questions).with_foreign_key('author_id').dependent(:nullify) }
    it { should have_many(:answers).with_foreign_key('author_id').dependent(:nullify) }
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
        expect(user.author_of?(question)).to eq true
      end

      it "returns false on somebody's question" do
        expect(user.author_of?(other_question)).to eq false
      end
    end
  end
end
