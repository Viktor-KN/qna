require 'rails_helper'

RSpec.describe 'Commentable', type: :model do
  with_model :WithCommentable do
    model { include Commentable }
  end

  describe 'Associations' do
    subject { WithCommentable.create! }

    it { should have_many(:comments).dependent(:destroy) }
  end
end
