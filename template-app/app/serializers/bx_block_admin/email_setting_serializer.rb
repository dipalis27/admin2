
# == Schema Information
#
# Table name: email_settings
#
#  id                            :bigint           not null, primary key
#  title                         :string
#  content                       :text
#  event_name                    :integer
#  slug                          :string
#  email_setting_category_id     :integer

module BxBlockAdmin
  class EmailSettingSerializer < BuilderBase::BaseSerializer
    attributes :title, :content, :event_name

    attribute :email_category do |obj|
      obj.email_setting_category.try(:name)
    end
  end
end