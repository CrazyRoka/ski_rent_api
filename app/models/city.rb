class City < ApplicationRecord
  has_many :citizens, class_name: 'User', foreign_key: 'city_id'
  has_many :items, through: :citizens
end
