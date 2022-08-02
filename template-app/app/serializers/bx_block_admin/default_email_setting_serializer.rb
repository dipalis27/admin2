
# == Schema Information
#
# Table name: email_settings
#
#  id                            :bigint           not null, primary key
#  brand_name                    :string
#  from_email                    :string
#  recipient_email               :string
#  contact_us_email_copy_to      :string
#  send_email_copy_method        :string
#  logo => (image attribute)

module BxBlockAdmin
  class DefaultEmailSettingSerializer < BuilderBase::BaseSerializer
    attributes :id, :brand_name, :from_email, :recipient_email, :contact_us_email_copy_to, :send_email_copy_method

    attribute :logo do |obj|
      if obj.logo.present?
        $hostname + Rails.application.routes.url_helpers.rails_blob_url(obj.logo, only_path: true)
      end
    end
  end
end