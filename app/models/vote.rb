class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: { scope: %i[votable_type votable_id] }
  validates :result, inclusion: { in: [-1, 1] }

  def up?
    result == 1
  end

  def down?
    result == -1
  end
end
