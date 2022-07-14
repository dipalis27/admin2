module BxBlockAdmin
  class StoreDetailSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :currency_type, :phone_number, :country, :address_state_id, :address, :zipcode
  end
end
