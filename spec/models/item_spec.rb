require 'rails_helper'

describe Item do
  context 'relationship' do
    subject(:item) { Item.new }
    it 'should have many bookings' do
      expect { item.bookings.build }.not_to raise_error
    end

    it 'should have many received reviews' do
      expect { item.received_reviews.build }.not_to raise_error
    end

    it 'should have owner' do
      expect { item.owner = User.new }.not_to raise_error
    end

    it 'should have one city through user' do
      expect { item.city = City.new }.not_to raise_error
    end

    it 'should have one category' do
      expect { item.category = Category.new }
    end

    it 'should have many options' do
      expect { item.options.build }.not_to raise_error
    end
  end

  context 'filtering' do
    let(:user){ create(:user) }

    let(:boots_category) { create(:category, name: 'Boots') }
    let(:ski_category) { create(:category, name: 'Skies') }

    let!(:ski) { create(:item, name: 'mountain_ski', owner: user, category: ski_category) }
    let!(:boot) { create(:item, name: 'boot', owner: user, category: boots_category) }

    let(:filter_boot_size) { create(:filter, filter_name: 'size', category: boots_category) }
    let(:filter_ski_size) { create(:filter, filter_name: 'size', category: ski_category) }

    let!(:medium_boot_size) { create(:option, filter: filter_boot_size, option_value: '40') }
    let!(:medium_ski_size) { create(:option, filter: filter_ski_size, option_value: '60') }

    context 'by category' do
      let(:items) { Item.of_category('Boots') }

      it 'should return all boots' do
        expect(items.count).to eq(1)
        expect(items[0]).to eq(boot)
      end
    end

    context 'by name' do
      let(:skies_items) { Item.with_name('ski') }
      let(:items_with_o) { Item.with_name('o') }

      it 'should return all skies' do
        expect(skies_items.count).to eq(1)
        expect(skies_items[0]).to eq(ski)
      end

      it 'should return all items with name rlike "o"' do
        expect(items_with_o.count).to eq(2)
      end
    end

    context 'by options' do
      let(:medium_size_boots) do
        ski.options << medium_ski_size
        boot.options << medium_boot_size
        ski.save
        boot.save
        Item.with_options(size: 40)
      end

      it 'should return medium boots' do
        expect(medium_size_boots.count).to eq(1)
        expect(medium_size_boots[0]).to eq(boot)
      end
    end
  end
end