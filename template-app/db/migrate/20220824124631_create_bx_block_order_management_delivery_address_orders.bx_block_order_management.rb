# This migration comes from bx_block_order_management (originally 20210330162194)
class CreateBxBlockOrderManagementDeliveryAddressOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :delivery_address_orders do |t|
      t.references :order, null: false, foreign_key: true
      t.references :delivery_address, null: false, foreign_key: true

      t.timestamps
    end
  end
end
