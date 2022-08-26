module BxBlockAdmin
  class CustomerSerializer < BuilderBase::BaseSerializer
    attributes :id, :full_name, :email, :activated, :full_phone_number, :country_code, :phone_number

    attribute :delivery_addresses do |object|
      DeliveryAddressSerializer.new(object.delivery_addresses).serializable_hash
    end

    attribute :image do |object|
      $hostname + Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true) if object.image.attached?
    end
  end
end
