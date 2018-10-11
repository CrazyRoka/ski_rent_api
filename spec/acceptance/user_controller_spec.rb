require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource UserController do
  header 'Content-Type', 'application/json'

  let(:raw_post) { params.to_json }

  post '/api/sign_up' do
    parameter :email, 'User email', required: true, scope: :user
    parameter :password, 'User password', required: true, scope: :user

    context 'Successfull' do
      let(:email) { 'some@email.com' }
      let(:password) { 'example' }

      example 'Sign up' do
        expect { do_request }.to change { User.count }.by(1)
        expect(status).to eq(201)
        expect(response_body).to include('jwt')
      end
    end

    context 'Failed' do
      let(:email) { 'some@email.com' }
      let(:password) { 'example' }
      let!(:user) { create(:user, email: email, password: password) }

      example 'Invalid sign up' do
        expect { do_request }.to change { User.count }.by(0)
        expect(status).to eq(403)
      end
    end
  end

  patch 'api/users' do
    header 'Authorization', :authorization_header

    parameter :name, "User name", required: false, scope: :user
    parameter :city_id, "Users city id", required: false, scope: :user

    let(:user) { create(:user) }
    let(:authorization_header) do
      "Bearer #{Knock::AuthToken.new(payload: { sub: user.id }).token}"
    end

    context 'Valid params' do
      let(:city_id) { create(:city, name: 'Havana').id }
      let(:name) { 'NewName' }

      context 'Updating', document: false do
        example_request 'Update name' do
          expect(User.last.name).to eq(name)
        end

        example_request 'Update city' do
          expect(User.last.city_id).to eq(city_id)
        end
      end

      example_request 'Update user' do
        expect(response_body).to eq(UserRepresenter.new(user.reload).to_json)
      end
    end
  end

  get '/api/users/me' do
    header 'Authorization', :authorization_header

    let(:user) { create(:user) }
    let(:authorization_header) do
      "Bearer #{Knock::AuthToken.new(payload: { sub: user.id }).token}"
    end

    context 'User profile' do
      example_request 'Get my profile' do
        expect(status).to eq(200)
        expect(response_body).to eq(UserRepresenter.new(user).to_json)
      end
    end
  end
end
