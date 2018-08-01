require 'rails_helper'

describe Item do
  context 'relationship' do
    subject(:item) { described_class.new }
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

    let!(:ski) { create(:item, daily_price_cents: 400, name: 'mountain ski', owner: user, category: ski_category) }
    let!(:boot) { create(:item, daily_price_cents: 300, name: 'boot', owner: user, category: boots_category) }

    let(:filter_boot_size) { create(:filter, filter_name: 'size', category: boots_category) }
    let(:filter_ski_size) { create(:filter, filter_name: 'size', category: ski_category) }

    context 'by category' do
      let(:items) { described_class.of_category([boots_category.id]) }

      it 'should return all boots' do
        expect(items.count).to eq(1)
        expect(items[0]).to eq(boot)
      end
    end

    context 'by name' do
      let(:skies_items) { described_class.with_name('ski') }
      let(:items_with_o) { described_class.with_name('o') }

      it 'should return all skies' do
        expect(skies_items.count).to eq(1)
        expect(skies_items[0]).to eq(ski)
      end

      it 'should return all items with name rlike "o"' do
        expect(items_with_o.count).to eq(0)
      end
    end

    context 'by options' do
      let!(:medium_boot_size) { create(:option, filter: filter_boot_size, option_value: '40') }
      let!(:medium_ski_size) { create(:option, filter: filter_ski_size, option_value: '60') }
      let(:medium_size_boots) do
        ski.options << medium_ski_size
        boot.options << medium_boot_size
        described_class.by_options([medium_boot_size.id])
      end

      it 'should return medium boots' do
        expect(medium_size_boots.count).to eq(1)
        expect(medium_size_boots[0]).to eq(boot)
      end
    end

    context 'by price range' do
      it 'should return items with suitable cost' do
        expect(described_class.by_cost(3, 800, 1400).count).to eq(2)
        expect(described_class.by_cost(3, 900, 1199).count).to eq(1)
        expect(described_class.by_cost(3, 901, 1200).count).to eq(1)
        expect(described_class.by_cost(2, 100, 200).count).to eq(0)
      end

      it 'should return zero on swapped ranges' do
        expect(described_class.by_cost(3, 1400, 800).count).to eq(0)
      end
    end

    context 'by booking date range' do
      let!(:booking) do
        Booking.create(item: ski, renter: user, start_date: Time.now,
                       end_date: Time.now + 3.days, cost_cents: 3 * ski.daily_price_cents)
      end

      it 'should return items, available between dates' do
        items = described_class.available_in(Time.now + 1.day, Time.now + 2.day)
        expect(items.count).to eq(1)
        expect(items.include?(boot)).to eq(true)

        expect(described_class.available_in(Time.now + 4.day, Time.now + 5.days).count).to eq(2)

        expect(described_class.available_in(Time.now + 5.day, Time.now + 4.days).count).to eq(0)
      end
    end
  end

  context 'csv' do
    context 'import items from csv' do
      let!(:user) { create(:user) }
      let(:file_content) { File.read(Rails.root.join('spec', 'csv', 'item.csv')) }

      it 'should create 4 items' do
        expect do
          ImportItemsCsv.new.with_step_args(validate: [user: user])
                        .call(file_content)
        end.to change { described_class.count }.by(4)
      end
    end
  end
end
