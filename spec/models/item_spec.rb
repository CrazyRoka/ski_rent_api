require 'rails_helper'

describe Item do
  context 'relationship' do
    subject(:item) { Item.new }
    it 'should have many bookings' do
      expect { item.bookings.build }.not_to raise_error
    end

    it 'should have many received reviews' do
      expect { item.received_reviews.build }.not_to raise_error
    end

    it 'should have owner' do
      expect { item.owner = User.new }.not_to raise_error
    end

    it 'should have one city through user' do
      item.owner = User.new
      expect { item.city = City.new }.not_to raise_error
    end
  end
end