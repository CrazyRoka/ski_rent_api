require 'rails_helper'

describe City do
  context 'relationship' do
    subject(:city) { described_class.new }

    it 'should have citizens' do
      expect { city.citizens.build }.not_to raise_error
    end

    it 'should have many items' do
      expect { city.items.build }.not_to raise_error
    end
  end
end
