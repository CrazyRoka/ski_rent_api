require 'rails_helper'

describe Review do
  context 'relationship' do
    subject(:review) { described_class.new }
    it 'should belongs to author' do
      expect { review.author = User.new }.not_to raise_error
    end

    it 'should belongs to reviewable object' do
      expect { review.reviewable = User.new }.not_to raise_error
      expect { review.reviewable = Item.new }.not_to raise_error
    end
  end

  context 'validation' do
    let(:author) { create(:user, email: 'author@email.com') }
    let(:item_owner) { create(:user, email: 'item_owner@email.com') }
    let(:review) do
      described_class.new(author: author, reviewable: item_owner,
                 description: "It's amazing")
    end

    it 'should have author, that dealt with item and user already' do
      expect(review.valid?).to eq(false)

      item = create(:item, owner: item_owner)
      item.bookings << Booking.create(item: item, renter: author)
      expect(review.valid?).to eq(true)

      review.reviewable = item
      expect(review.valid?).to eq(true)
    end
  end
end
