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
  end
end