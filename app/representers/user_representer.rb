class UserRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :name
  property :city, class: City do
    property :id
    property :name
  end
  property :email
  collection :items, extend: ItemRepresenter, class: Item
end
