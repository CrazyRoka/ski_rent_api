class Item < ApplicationRecord
  validates :name, :daily_price_cents, presence: true

  belongs_to :owner, class_name: 'User'
  has_many :bookings, dependent: :destroy
  has_many :received_reviews, class_name: 'Review', as: :reviewable, dependent: :destroy
  has_and_belongs_to_many :options
  has_one :city, through: :owner
  belongs_to :category, optional: true

  scope :of_category, ->(category) { where(category: Category.find_by_name(category)) }
  scope :with_name, ->(name) { where('name ILIKE ? OR name ILIKE ?', "#{name}%", "% #{name}%")}
  scope :by_options, ->(option_ids) { joins(:options).where(options: {id: option_ids}) }
  scope :by_cost, ->(days_number, lower_price, upper_price) { where((arel_table[:daily_price_cents] * days_number)
                                                                    .between(lower_price..upper_price)) }

  def self.available_in(from_date, to_date)
    return where(id: []) if from_date > to_date

    items = arel_table
    bookings = Booking.arel_table

    items = items.join(bookings, Arel::Nodes::OuterJoin).on(items[:id].eq(bookings[:item_id]))

    joins(items.join_sources).where(
      bookings[:start_date].gt(to_date)
      .or(bookings[:end_date].lt(from_date))
      .or(bookings[:start_date].eq(nil))
    )
  end
end