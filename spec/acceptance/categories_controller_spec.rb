require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource CategoriesController do
  header 'Content-Type', 'application/json'
  header 'Authorization', :authorization_header

  let(:raw_post) { params.to_json }
  let(:user) { create(:user) }
  let(:authorization_header) do
    "Bearer #{Knock::AuthToken.new(payload: { sub: user.id }).token}"
  end

  get '/api/categories' do
    let!(:categories) { 10.times.map { create(:category) } }
    let!(:filters) { 15.times.map { |i| create(:filter, category: categories[i % 10]) } }
    let!(:options) { 25.times.map { |i| create(:option, filter: filters[i % 15]) } }

    example_request 'Get categories' do
      expect(response_body).to eq({categories: categories.map{|c| CategoryRepresenter.new(c)}}.to_json)
      expect(status).to eq(200)
    end
  end
end
