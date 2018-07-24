require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'UserTokenController' do
  header "Content-Type", "application/json"

  let(:raw_post) { params.to_json }

  post '/api/user_token' do
    parameter :email, "User email", required: true, scope: :auth
    parameter :password, "User password", required: true, scope: :auth

    context 'valid log in' do
      let(:user) { create(:user, password: password) }
      let(:email) { user.email }
      let(:password) { 'example' }

      example_request 'should be 201' do
        expect(status).to eq(201)
        expect(response_body).to include('jwt')
      end
    end

    context 'invalid log in' do
      let(:email) { 'j@email.com' }
      let(:password) { 'something else' }

      example_request 'should be 404' do
        expect(status).to eq(404)
      end
    end
  end
end