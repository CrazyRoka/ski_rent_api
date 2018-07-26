class Option < ApplicationRecord
  belongs_to :filter
  has_and_belongs_to_many :items
end