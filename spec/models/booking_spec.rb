require 'rails_helper'

describe Booking do
  context 'relationship' do
    subject(:booking) { described_class.new }
    it 'should belongs to item' do
      expect { booking.item = Item.new }.not_to raise_error
    end

    it 'should belongs to renter' do
      expect { booking.renter = User.new }.not_to raise_error
    end
  end
end
