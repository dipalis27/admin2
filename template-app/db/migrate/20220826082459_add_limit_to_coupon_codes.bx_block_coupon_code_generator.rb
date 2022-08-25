class AddLimitToCouponCodes < ActiveRecord::Migration[6.0]
  def change
    add_column :coupon_codes, :limit, :integer
  end
end
