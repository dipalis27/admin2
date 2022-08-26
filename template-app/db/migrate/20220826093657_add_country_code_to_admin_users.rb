class AddCountryCodeToAdminUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :country_code, :integer
  end
end
