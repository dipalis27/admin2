module BxBlockAdmin
  class AddressStateSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :code, :gst_code, :country_id, :created_at, :updated_at
  end
end