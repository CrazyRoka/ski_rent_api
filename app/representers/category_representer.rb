class CategoryRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :name
  collection :filters, class: Filter do
    property :id
    property :filter_name
    collection :options, class: Option do
      property :id
      property :option_value
    end
  end
end
