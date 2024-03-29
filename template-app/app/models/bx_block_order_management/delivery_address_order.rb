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
  class DeliveryAddressOrder < BxBlockOrderManagement::ApplicationRecord
    self.table_name = :delivery_address_orders

    belongs_to :order
    belongs_to :delivery_address

    accepts_nested_attributes_for :delivery_address

    scope :address_ids, -> (ids) { where(delivery_address_id: ids ) }
  end
end
