require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource UserController do
  header "Content-Type", "application/json"

  let(:raw_post) { params.to_json }

  post '/api/sign_up' do
    parameter :email, "User email", required: true, scope: :user
    parameter :password, "User password", required: true, scope: :user
    parameter :city, "Items city", required: false, scope: :user

    context 'successful sign up' do
      let(:email) { 'some@email.com' }
      let(:password) { 'example' }

      example 'should be 201' do
        expect { do_request }.to change { User.count }.by(1)
        expect(status).to eq(201)
        expect(response_body).to include('jwt')
      end
    end

    context 'invalid sign up' do
      let(:email) { 'some@email.com' }
      let(:password) { 'example' }

      example 'should be 404' do
        create(:user, email: email, password: password)
        expect { do_request }.to change { User.count }.by(0)
        expect(status).to eq(404)
      end
    end
  end

  get '/api/users/me' do
    header 'Authorization', :authorization_header

    let(:user) { create(:user) }
    let(:authorization_header) do
      "Bearer #{Knock::AuthToken.new(payload: { sub: user.id }).token}"
    end

    context 'user profile' do
      example_request 'should return user info' do
        expect(response.status).to eq(200)
        expect(response_body).to eq(user.to_json)
      end
    end
  end
end