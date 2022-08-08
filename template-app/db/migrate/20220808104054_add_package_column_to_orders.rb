class AddPackageColumnToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :package_id, :integer
  end
end
