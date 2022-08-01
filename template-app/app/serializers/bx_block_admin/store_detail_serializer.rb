module BxBlockAdmin
  class StoreDetailSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :contact_us_email_copy, :order_email_copy, :currency_type, :phone_number, :address_state_id, :address, :zipcode
    attribute :country do |object|
      if object.store_country.present?
        object.store_country.name
      else
        object.country
      end
    end
  end
end
