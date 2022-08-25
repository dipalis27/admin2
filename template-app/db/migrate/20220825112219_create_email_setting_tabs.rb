class CreateEmailSettingTabs < ActiveRecord::Migration[6.0]
  def change
    create_table :email_setting_tabs do |t|
      t.string :name

      t.timestamps
    end
  end
end
