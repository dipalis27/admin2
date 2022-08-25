class AddEmailSettingCategoryToEmailSetting < ActiveRecord::Migration[6.0]
  def change
    add_column :email_settings, :email_setting_category_id, :integer
  end
end
