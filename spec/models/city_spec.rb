require 'rails_helper'

describe City do
  context 'relationship' do
    subject(:city) { City.new }
    it 'should have owner' do
      expect { city.owner = User.new }.not_to raise_error
    end

    it 'should have many items' do
      expect { city.items.build }.not_to raise_error
    end
  end
end