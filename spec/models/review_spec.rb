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
end