class ItemRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :owner_id
  property :name
  property :daily_price_cents
  property :category
  collection :options, extend: OptionRepresenter, class: Option
end
