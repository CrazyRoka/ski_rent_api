require 'rails_helper'

describe Category do
  context 'relationship' do
    subject(:category) { described_class.new }
    it 'should have many items' do
      expect { category.items.build }.not_to raise_error
    end

    it 'should have many filters' do
      expect { category.filters.build }.not_to raise_error
    end
  end
end
