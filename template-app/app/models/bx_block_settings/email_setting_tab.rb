module BxBlockSettings
  class EmailSettingTab < ApplicationRecord
    self.table_name = :email_setting_tabs

    has_many :email_setting_categories, class_name: "BxBlockSettings::EmailSettingCategory"

    validates_presence_of :name
  end    
end
