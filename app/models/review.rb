class Review < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :reviewable, polymorphic: true

  validate :author_has_permissions_to_review

  def author_has_permissions_to_review
    case self.reviewable_type
    when 'User'
      items = reviewable.items
      deal = false
      items.each do |item|
        if item.bookings.any? { |booking| booking.renter == author }
          deal = true
        end
      end
      errors.add(:author, 'author didn`t deal with this item owner before') unless deal
    when 'Item'
      item = reviewable
      unless item.bookings.any? { |booking| booking.renter == author }
        errors.add(:author, 'author didn`t book this item before`')
      end
    end
  end
end