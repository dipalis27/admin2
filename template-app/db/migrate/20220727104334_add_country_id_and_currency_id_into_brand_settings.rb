class AddCountryIdAndCurrencyIdIntoBrandSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :brand_settings, :country_id, :integer
    add_column :brand_settings, :currency_id, :integer
  end
end
