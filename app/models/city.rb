class City < ApplicationRecord
  has_one :owner, class_name: 'User', foreign_key: 'city_id'
  has_many :items, through: :owner
end