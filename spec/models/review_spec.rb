require 'rails_helper'

describe Review do
  context 'relationship' do
    subject(:review) { Review.new }
    it 'should belongs to author' do
      expect { review.author = User.new }.not_to raise_error
    end

    it 'should belongs to reviewable object' do
      expect { review.reviewable = User.new }.not_to raise_error
      expect { review.reviewable = Item.new }.not_to raise_error
    end
  end

  context 'validation' do
    it 'should have author, that dealt with item and user already' do
      author = User.new
      item_owner = User.new
      review = Review.new(author: author, reviewable: item_owner)
      expect(review.valid?).to eq(false)

      item = item_owner.items.build
      item.bookings << Booking.new(item: item, renter: author)
      expect(review.valid?).to eq(true)

      review.reviewable_type = 'item'
      review.reviewable_id = item.id
      expect(review.valid?).to eq(true)
    end
  end
end