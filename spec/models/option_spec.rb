require 'rails_helper'

describe Option do
  context 'relationship' do
    subject(:option) { described_class.new }
    it 'should belongs to one filter' do
      expect { option.filter = Filter.new }.not_to raise_error
    end

    it 'should have many items' do
      expect { option.items.build }.not_to raise_error
    end
  end
end
