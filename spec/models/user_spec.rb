require 'rails_helper'

describe User do
  context 'relationship' do
    subject(:user) { described_class.new }
    it 'should have many items' do
      expect { user.items.build }.not_to raise_error
    end

    it 'should have many reviews' do
      expect { user.reviews.build }.not_to raise_error
    end

    it 'should have many received_reviews' do
      expect { user.received_reviews.build }.not_to raise_error
    end

    it 'should belongs to city' do
      expect { user.city = City.new }.not_to raise_error
    end

    it 'should have item reviews' do
      expect { user.received_item_reviews.build }.not_to raise_error
    end

    it 'should have many bookings' do
      expect { user.bookings.build }.not_to raise_error
    end

    it 'should have many received transactions' do
      expect { user.received_transactions.build }.not_to raise_error
    end

    it 'should have many payed transactions' do
      expect { user.payed_transactions.build }.not_to raise_error
    end
  end

  context 'authentication' do
    let(:city) { create(:city) }
    subject(:user) { create(:user, password: 'john', email: 'john@gmail.com') }
    it 'should have correct password' do
      user.password_digest = ''
      expect(user.valid?).to eq(false)
    end

    it 'should have correct email' do
      user.email = 'something_else'
      expect(user.valid?).to eq(false)
    end
  end
end
