class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :recipient, class_name: 'User', optional: true

  has_one_attached :image

  validates :title, presence: true
  validate :validate_image_presence

  private

  def validate_image_presence
    errors.add(:image, 'must be attached') unless image.attached?
  end
end
