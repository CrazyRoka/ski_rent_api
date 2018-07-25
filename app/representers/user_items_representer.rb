module UserItemsRepresenter
  include Roar::JSON

  collection :items, extend: ItemRepresenter, class: Item
end
