require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Associations' do
    it { should belong_to(:commentable) }
    it { should belong_to(:author).class_name('User')}
  end

  describe 'Validations' do
    it { should validate_presence_of :body }
  end

  describe 'Callbacks' do
    describe "#broadcast_new_comment" do
      it "is called after new record is created" do
        comment = build(:comment)

        expect(comment).to receive(:broadcast_new_comment)
        comment.save!
      end
    end
  end
end
