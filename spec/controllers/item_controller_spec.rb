require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource UserController do
  header "Content-Type", "application/json"
  header 'Authorization', :authorization_header

  let(:raw_post) { params.to_json }
  let(:user) { create(:user) }
  let(:authorization_header) do
    "Bearer #{Knock::AuthToken.new(payload: { sub: user.id }).token}"
  end

  get '/api/item' do
    parameter :id, "Item id", scope: :item

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
        expect(response_status).to eq(401)
      end
    end
  end

  get '/api/items' do
    let!(:ski) { create(:item, owner: user, name: 'ski') }
    let!(:fast_ski) { create(:item, owner: user, name: 'fast_ski') }
    let(:items) { user.extend(UserItemsRepresenter) }

    example_request 'should return all user items' do
      expect(response.status).to eq(200)
      expect(response_body).to eq(items.to_json)
    end
  end

  post '/api/item/update' do
    parameter :id, "Item id", scope: :item
    parameter :name, "Item name", scope: :item
    parameter :daily_price_cents, "Item daily price", scope: :item
    parameter :owner_id, "Item owner id", scope: :item

    let(:item) { create(:item, owner: user) }
    let(:id) { item.id }

    context 'update name' do
      let(:name) { 'example' }

      example_request '200' do
        expect(response_status).to eq(200)
        expect(item.reload.name).to eq('example')
        expect(response_body).to eq(item.reload.extend(ItemRepresenter).to_json)
      end
    end

    context 'update price' do
      let(:daily_price_cents) { 350 }

      example_request '200' do
        expect(response_status).to eq(200)
        expect(item.reload.daily_price_cents).to eq(350)
        expect(response_body).to eq(item.reload.extend(ItemRepresenter).to_json)
      end
    end

    context 'update owner' do
      let(:other_owner) { create(:user, email: 'daniel@email.com') }
      let(:owner_id) { other_owner.id }

      example_request '200' do
        expect(response_status).to eq(200)
        expect(item.reload.owner.id).to eq(other_owner.id)
        expect(response_body).to eq(item.reload.extend(ItemRepresenter).to_json)
      end
    end
  end

  post '/api/item/destroy' do
    parameter :id, "Item id", scope: :item

    context 'delete item' do
      let(:item) { create(:item, owner: user) }
      let!(:id) { item.id }

      example '200' do
        expect { do_request }.to change { Item.count }.by(-1)
        expect(response_status).to eq(200)
        expect(response_body).to eq(item.extend(ItemRepresenter).to_json)
      end
    end

    context 'invalid owner' do
      let(:other_owner) { create(:user, email: 'daniel@test.com') }
      let(:item) { create(:item, owner: other_owner) }
      let!(:id) { item.id }

      example '401' do
        expect { do_request }.not_to change { Item.count }
        expect(response_status).to eq(401)
      end
    end
  end

  post '/api/item/create' do
    parameter :name, "Item name", scope: :item
    parameter :daily_price_cents, "Item daily price", scope: :item

    context 'create item' do
      let!(:name) { 'example' }
      let!(:daily_price_cents) { 300 }

      example '201' do
        expect { do_request }.to change { Item.count }.by(1)
        expect(response_status).to eq(201)
        expect(response_body).to eq(Item.last.extend(ItemRepresenter).to_json)
      end
    end
  end
end