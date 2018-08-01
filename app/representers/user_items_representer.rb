class UserItemsRepresenter < Roar::Decorator
  include Roar::JSON

  collection :items, extend: ItemRepresenter, class: Item
end
