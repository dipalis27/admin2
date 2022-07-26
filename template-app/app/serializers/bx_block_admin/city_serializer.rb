module BxBlockAdmin
  class CitySerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :address_state_id, :created_at, :updated_at
  end
end