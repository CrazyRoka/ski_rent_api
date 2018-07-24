module UserRepresenter
  include Roar::JSON
  
  property :name  
  property :password_digest  
  property :email  
  property :city  
end
