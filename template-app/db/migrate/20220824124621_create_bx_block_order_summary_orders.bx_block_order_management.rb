# This migration comes from bx_block_order_management (originally 20210330162184)
class CreateBxBlockOrderSummaryOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :order_number
      t.float :amount
      t.timestamps
    end
  end
end
