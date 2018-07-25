FactoryBot.define do
  factory :city, class: City do
    name 'default'
  end

  factory :user, class: User do
    name     'John'
    email    'john@email.com'
    password 'example'
    city     { build(:city) }
  end

  factory :item, class: Item do
    owner           { create(:user) }
    name              'ski'
    daily_price_cents 400
  end
end