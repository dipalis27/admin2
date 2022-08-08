class AddWhatsappMessageAddressLine2InBrandSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :brand_settings, :whatsapp_message, :string
    add_column :brand_settings, :address_line_2, :string
  end
end
