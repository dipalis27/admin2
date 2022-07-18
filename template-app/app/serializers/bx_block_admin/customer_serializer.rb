module BxBlockAdmin
  class CustomerSerializer < BuilderBase::BaseSerializer
    attributes :id, :full_name, :email, :activated, :full_phone_number, :image

    attribute :delivery_addresses do |object|
      DeliveryAddressSerializer.new(object.delivery_addresses).serializable_hash
    end
  end
end
