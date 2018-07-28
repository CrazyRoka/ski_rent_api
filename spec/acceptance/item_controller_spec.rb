require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource ItemsController do
  header "Content-Type", "application/json"
  header 'Authorization', :authorization_header

  let(:raw_post) { params.to_json }
  let(:user) { create(:user) }
  let(:authorization_header) do
    "Bearer #{Knock::AuthToken.new(payload: { sub: user.id }).token}"
  end

  get '/api/items/:id' do
    context 'item exist' do
      let(:item) { create(:item, owner: user) }
      let(:id) { item.id }

      example_request 'should return item' do
        expect(response_body).to eq(item.extend(ItemRepresenter).to_json)
      end
    end

    context 'item belongs to another user' do
      let(:other_user) { create(:user, email: 'daniel@email.com') }
      let(:item) { create(:item, owner: other_user) }
      let(:id) { item.id }

      example_request 'authorization fail' do
        expect(status).to eq(403)
      end
    end
  end

  get '/api/items' do
    let(:boots) { create(:category, name: 'boots') }
    let(:skies) { create(:category, name: 'skies') }

    let(:size_filter) { create(:filter, category: boots, filter_name: 'size') }

    let(:size_m) { create(:option, filter: size_filter, option_value: 'M') }
    let(:size_l) { create(:option, filter: size_filter, option_value: 'L') }

    let!(:booking) { Booking.create(renter: user, item: ski, start_date: Time.now, end_date: Time.now + 5.days) }

    let!(:ski) { create(:item, owner: user, name: 'ski', category: skies, daily_price_cents: 100) }
    let!(:fast_ski) { create(:item, owner: user, name: 'fast_ski', category: skies) }
    let!(:adidas) { create(:item, owner: user, name: 'adidas boots', category: boots) }

    context 'list all user items' do
      let(:items) { user.extend(UserItemsRepresenter) }

      example_request 'should return all user items' do
        expect(status).to eq(200)
        expect(response_body).to eq(items.to_json)
      end
    end

    parameter :of_category, 'Items categories to filter'

    context 'list filtered items by skies category' do
      let(:of_category) { [skies.id] }
      let(:items) { User.new(items: (user.items & Item.of_category(of_category))).extend(UserItemsRepresenter) }

      example_request 'should return all user skies' do
        expect(status).to eq(200)
        expect(response_body).to eq(items.to_json)
      end
    end

    context 'list filtered items by boots category' do
      let(:of_category) { [boots.id] }
      let(:items) { User.new(items: (user.items & Item.of_category(of_category))).extend(UserItemsRepresenter) }

      example_request 'should return all user boots' do
        expect(status).to eq(200)
        expect(response_body).to eq(items.to_json)
      end
    end

    context 'list filtered items by boots category' do
      let(:of_category) { [boots.id] }
      let(:items) { User.new(items: (user.items & Item.of_category(of_category))).extend(UserItemsRepresenter) }

      example_request 'should return all user boots' do
        expect(status).to eq(200)
        expect(response_body).to eq(items.to_json)
      end
    end

    parameter :by_options, 'Item options to filter'

    context 'list filtered items by M size option' do
      before(:each) do
        adidas.options << size_m
      end
      let(:items) { User.new(items: (user.items & Item.by_options(by_options))).extend(UserItemsRepresenter) }
      let(:by_options) { [size_m.id] }

      example_request 'should return adidas' do
        expect(status).to eq(200)
        expect(response_body).to eq(items.to_json)
      end
    end

    parameter :with_name, 'Item name to filter'

    context 'list filtered items by name' do
      let(:items) { User.new(items: (user.items & Item.with_name(with_name))).extend(UserItemsRepresenter) }
      let(:with_name) { 'boots' }

      example_request 'should return adidas' do
        expect(status).to eq(200)
        expect(response_body).to eq(items.to_json)
      end
    end

    parameter :by_cost, 'Item cost filter'

    context 'list filtered items by cost range' do
      let(:items) { User.new(items: (user.items & Item.by_cost(*by_cost.values))).extend(UserItemsRepresenter) }
      let(:by_cost) { {days_number: 3, lower_price: 200, upper_price: 400} }

      example_request 'should return adidas' do
        expect(status).to eq(200)
        expect(response_body).to eq(items.to_json)
      end
    end

    parameter :available_in, 'Item date filter'

    context 'list filtered items by availability' do
      let(:items) { User.new(items: (user.items & Item.available_in(*available_in.values))).extend(UserItemsRepresenter) }
      let(:available_in) { {from_date: Time.now, to_date: Time.now + 3.days} }

      example_request 'should return all except ski' do
        expect(status).to eq(200)
        expect(response_body).to eq(items.to_json)
      end
    end
  end

  patch '/api/items/:id' do
    parameter :name, "Item name", scope: :item
    parameter :daily_price_cents, "Item daily price", scope: :item
    parameter :owner_id, "Item owner id", scope: :item

    let(:item) { create(:item, owner: user) }
    let(:id) { item.id }

    context 'update name' do
      let(:name) { 'example' }

      example_request '200' do
        expect(status).to eq(200)
        expect(item.reload.name).to eq('example')
        expect(response_body).to eq(item.reload.extend(ItemRepresenter).to_json)
      end
    end

    context 'update price' do
      let(:daily_price_cents) { 350 }

      example_request '200' do
        expect(status).to eq(200)
        expect(item.reload.daily_price_cents).to eq(350)
        expect(response_body).to eq(item.reload.extend(ItemRepresenter).to_json)
      end
    end

    context 'update owner' do
      let(:other_owner) { create(:user, email: 'daniel@email.com') }
      let(:owner_id) { other_owner.id }

      example_request '200' do
        expect(status).to eq(200)
        expect(item.reload.owner.id).to eq(other_owner.id)
        expect(response_body).to eq(item.reload.extend(ItemRepresenter).to_json)
      end
    end
  end

  delete '/api/items/:id' do
    parameter :id, "Item id", scope: :item

    context 'delete item' do
      let(:item) { create(:item, owner: user) }
      let!(:id) { item.id }

      example '200' do
        expect { do_request }.to change { Item.count }.by(-1)
        expect(status).to eq(200)
        expect(response_body).to eq(item.extend(ItemRepresenter).to_json)
      end
    end

    context 'item belongs to another user' do
      let(:other_user) { create(:user, email: 'daniel@email.com') }
      let!(:item) { create(:item, owner: other_user) }
      let(:id) { item.id }

      example 'authorization fail' do
        expect { do_request }.not_to change { Item.count }
        expect(status).to eq(403)
      end
    end
  end

  post '/api/items' do
    parameter :name, "Item name", scope: :item
    parameter :daily_price_cents, "Item daily price", scope: :item

    let!(:name) { 'example' }
    let!(:daily_price_cents) { 300 }

    context 'create item' do
      example '201' do
        expect { do_request }.to change { Item.count }.by(1)
        expect(status).to eq(201)
        expect(response_body).to eq(Item.last.extend(ItemRepresenter).to_json)
      end
    end

    parameter :category_id, "Item category", scope: :item
    parameter :option_ids, "Item options", scope: :item

    context 'create item with category and options' do
      let!(:category_id) { create(:category).id }
      let!(:option_ids) { [create(:option).id, create(:option).id] }

      example '201' do
        expect { do_request }.to change { Item.count }.by(1)
        expect(status).to eq(201)
        expect(response_body).to eq(Item.last.extend(ItemRepresenter).to_json)
        expect(Item.last.options.map(&:id)).to eq(option_ids)
      end
    end
  end

  post '/api/items/import' do
    parameter :csv, 'Csv with items'

    context 'valid csv' do
      let!(:owner) { create(:user, id: 100, email: 'test@email.com') }
      let!(:csv) { File.read(Rails.root.join('spec', 'csv', 'item.csv')) }

      example 'should create items' do
        expect { do_request }.to change { Item.count }.by(4)
        expect(status).to eq(201)
      end
    end

    # context 'invalid csv' do
    #   example 'should create items' do
    #     expect { do_request }.not_to change(Item.count).by(4)
    #     expect(status).to eq(200)
    #   end
    # end
  end
end