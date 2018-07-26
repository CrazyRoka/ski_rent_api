class Item < ApplicationRecord
  validates :name, :daily_price_cents, presence: true

  belongs_to :owner, class_name: 'User'
  has_many :bookings, dependent: :destroy
  has_many :received_reviews, class_name: 'Review', as: :reviewable, dependent: :destroy
  has_and_belongs_to_many :options
  has_one :city, through: :owner
  belongs_to :category, optional: true

  scope :of_category, ->(category) { where(category: Category.find_by_name(category)) }
  scope :with_name, ->(name) { where('name ~ ?', name)}

  def self.with_options(options)
    items = Item.all
    filter = Filter.where(filter_name: options.keys)
    options = Option.where(filter: filter, option_value: options.values)
    items.select { |item| (item.options & options).any? }
  end
end