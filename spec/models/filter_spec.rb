require 'rails_helper'

describe Filter do
  context 'relationship' do
    subject(:filter) { Filter.new }
    it 'should have many options' do
      expect { filter.options.build }.not_to raise_error
    end

    it 'should belongs to one category' do
      expect { filter.category = Category.new }.not_to raise_error
    end
  end
end