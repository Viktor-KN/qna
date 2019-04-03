class Link < ApplicationRecord
  default_scope { order(:id) }

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true
end
