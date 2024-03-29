# == Schema Information
#
# Table name: delivery_address_orders
#
#  id                  :bigint           not null, primary key
#  order_id            :bigint           not null
#  delivery_address_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
module BxBlockOrderManagement
  class DeliveryAddressOrderSerializer < BuilderBase::BaseSerializer

    belongs_to :delivery_address, serializer: AddressesSerializer

    attributes *[
        :id,
        :order_id,
        :delivery_address_id,
        :created_at,
        :updated_at,
        :delivery_address
      ]

  end

end
