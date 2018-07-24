require 'rails_helper'

describe User do
  context 'relationship' do
    subject(:user) { User.new }
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
  end

  context 'authentication' do
    let(:city) { City.new(name: 'example') }
    subject(:user) { User.new(name: 'John', password: '', email: 'john@example.com', city: city) }
    it 'should have correct password' do
      expect(user.valid?).to eq(false)

      user.password = 'my_name_is_john'
      expect(user.valid?).to eq(true)
      p user.password_digest
    end
  end
end