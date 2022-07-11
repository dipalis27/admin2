module BxBlockSettings
  class EmailSettingCategory < ApplicationRecord
    self.table_name = :email_setting_categories

    belongs_to :email_setting_tab, class_name: "BxBlockSettings::EmailSettingTab"
    has_many :email_settings, class_name: "BxBlockSettings::EmailSetting"

    validates_presence_of :name
  end    
end
