require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'Associations' do
    it { should belong_to(:question) }
    it { should belong_to(:recipient).class_name('User').optional }

    it 'have one attached file' do
      expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
    end
  end

  describe 'Validations' do
    it { should validate_presence_of :title }
    it { should validate_attachment_presence_of :image }
  end
end
