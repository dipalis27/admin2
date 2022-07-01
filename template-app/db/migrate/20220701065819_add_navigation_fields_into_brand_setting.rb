class AddNavigationFieldsIntoBrandSetting < ActiveRecord::Migration[6.0]
  def change
    add_column :brand_settings, :navigation_item1, :string
    add_column :brand_settings, :navigation_item2, :string
    add_column :brand_settings, :is_whatsapp_integration, :boolean, default: false
  end
end
