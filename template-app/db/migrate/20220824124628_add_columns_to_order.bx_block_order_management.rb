# This migration comes from bx_block_order_management (originally 20210330162191)
class AddColumnsToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :is_group, :boolean, default: true
    add_column :orders, :is_availability_checked, :boolean, default: false
    add_column :orders, :shipping_charge, :decimal
    add_column :orders, :shipping_discount, :decimal
    add_column :orders, :shipping_net_amt, :decimal
    add_column :orders, :shipping_total, :decimal
    add_column :orders, :total_tax, :float
  end
end
