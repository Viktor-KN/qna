class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, foreign_key: 'author_id', dependent: :nullify
  has_many :answers, foreign_key: 'author_id', dependent: :nullify
  has_many :comments, foreign_key: 'author_id', dependent: :nullify
  has_many :rewards, foreign_key: 'recipient_id', dependent: :nullify
  has_many :votes, dependent: :nullify

  def author_of?(entry)
    entry.author_id == id
  end
end
