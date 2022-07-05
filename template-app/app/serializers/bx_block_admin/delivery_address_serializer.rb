module BxBlockAdmin
  class DeliveryAddressSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :flat_no, :address, :address_line_2, :city, :state, :country,
      :zip_code, :phone_number
  end
end
