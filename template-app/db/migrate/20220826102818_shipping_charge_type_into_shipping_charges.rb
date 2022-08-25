class ShippingChargeTypeIntoShippingCharges < ActiveRecord::Migration[6.0]
  def change
    add_column :shipping_charges, :free_shipping, :boolean, default: true
  end
end
