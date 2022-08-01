class AddOrderEmailCustomerEmailIntoBrandSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :brand_settings, :order_email_copy, :string
    add_column :brand_settings, :contact_us_email_copy, :string
  end
end
