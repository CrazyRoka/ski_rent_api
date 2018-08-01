class Review < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :reviewable, polymorphic: true

  validate :author_has_permissions_to_review

  def author_has_permissions_to_review
    case reviewable_type
    when 'User'
      bookings = Booking.where(renter: author).where(item: reviewable.items)
      errors.add(:author, 'bad item history') if bookings.empty?
    when 'Item'
      if Booking.where(renter: author).where(item: reviewable).empty?
        errors.add(:author, 'bad item history')
      end
    end
  end
end
