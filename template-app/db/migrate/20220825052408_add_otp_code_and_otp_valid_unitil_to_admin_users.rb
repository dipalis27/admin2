class AddOtpCodeAndOtpValidUnitilToAdminUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :otp_code, :integer
    add_column :admin_users, :otp_valid_until, :datetime
  end
end
