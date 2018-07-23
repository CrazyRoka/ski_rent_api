class Item < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :bookings, dependent: :destroy
  has_many :received_reviews, class_name: 'Review', as: :reviewable, dependent: :destroy
end