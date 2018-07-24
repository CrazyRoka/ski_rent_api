class Review < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :reviewable, polymorphic: true

  validate :author_has_permissions_to_review

  def author_has_permissions_to_review
    case reviewable_type
    when 'User'
      items = reviewable.items
      if items.none? { |item| item.bookings.any? { |booking| booking.renter == author } }
        errors.add(:author, 'author didn`t deal with this item owner before')
      end
    when 'Item'
      item = reviewable
      unless item.bookings.any? { |booking| booking.renter == author }
        errors.add(:author, 'author didn`t book this item before`')
      end
    end
  end
end