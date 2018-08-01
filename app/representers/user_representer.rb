class UserRepresenter < Roar::Decorator
  include Roar::JSON

  property :name
  property :email
end
