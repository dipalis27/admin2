class AddColumnToBrandSetting < ActiveRecord::Migration[6.0]
  def change
    add_column :brand_settings, :zipcode, :string
  end
end
