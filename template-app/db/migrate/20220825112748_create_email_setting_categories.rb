class CreateEmailSettingCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :email_setting_categories do |t|
      t.string :name
      t.references :email_setting_tab, null: false, foreign_key: true

      t.timestamps
    end
  end
end
