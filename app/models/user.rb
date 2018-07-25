class User < ApplicationRecord
  validates :email, :password_digest, presence: true
  validates :email, uniqueness: true

  has_many :items, foreign_key: 'owner_id', dependent: :destroy
  has_many :reviews, foreign_key: 'author_id', dependent: :destroy
  has_many :received_reviews, class_name: 'Review', as: :reviewable, dependent: :destroy
  has_many :received_item_reviews, through: :items, source: :received_reviews
  has_many :bookings, foreign_key: 'renter_id', dependent: :destroy
  belongs_to :city, optional: true

  has_secure_password
end