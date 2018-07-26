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

  def self.with_cost(days_number:, lower_price:, upper_price:)
    upper_price /= days_number.to_f
    lower_price /= days_number.to_f
    where('(daily_price_cents <= ?) AND (daily_price_cents >= ?)', upper_price, lower_price)
  end

  def self.available_in(date)
    items =  Item.joins(:bookings).where('(start_date <= ?) AND (end_date >= ?)', date, date)
    Item.where.not(id: items.map(&:id))
  end
end