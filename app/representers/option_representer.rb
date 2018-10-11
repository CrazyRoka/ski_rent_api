class OptionRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :option_value
  property :filter, class: Filter do
    property :id
    property :filter_name
  end
end
