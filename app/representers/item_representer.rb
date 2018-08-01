class ItemRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :name
  property :daily_price_cents
end
