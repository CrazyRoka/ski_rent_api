class User < ApplicationRecord
  has_many :items, foreign_key: 'owner_id', dependent: :destroy
  has_many :reviews, foreign_key: 'author_id', dependent: :destroy
  has_many :received_reviews, class_name: 'Review', as: :reviewable, dependent: :destroy
end