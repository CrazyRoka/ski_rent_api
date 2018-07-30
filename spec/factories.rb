FactoryBot.define do
  factory :city, class: City do
    name 'Lviv'
  end

  factory :user, class: User do
    name     'John'
    email    'john@email.com'
    password 'example'
    balance  1000
    city     { build(:city) }
  end

  factory :category, class: Category do
    name 'Skies'
  end

  factory :filter, class: Filter do
    category  { create(:category) }
    filter_name 'size'
  end

  factory :option, class: Option do
    filter     { create(:filter) }
    option_value '40'
  end

  factory :item, class: Item do
    owner           { create(:user) }
    category        { create(:category) }
    name              'ski'
    daily_price_cents 400
  end

  factory :transaction, class: MoneyTransaction do
    payer           { create(:user) }
    payee           { create(:user, email: 'something@else.com') }
    target          { create(:item, owner: payee) }
    payment_cents     500
  end
end