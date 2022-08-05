class AddWhatsappPhoneNumberAndCityIdIntoBrandSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :brand_settings, :area_code, :string
    add_column :brand_settings, :whatsapp_number, :string
    add_column :brand_settings, :city_id, :integer
  end
end
