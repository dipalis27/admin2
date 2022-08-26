module BxBlockAdmin
  class AdminUserSerializer < BuilderBase::BaseSerializer
    attributes :id, :email, :country_code, :phone_number, :name, :role

    attribute :permissions do |object|
      object.admin_permissions
    end

    attribute :store_name do |object|
      BxBlockStoreProfile::BrandSetting.last&.heading
    end

    attribute :currency_type do |object|
      BxBlockStoreProfile::BrandSetting.last&.currency_type
    end    
  end
end
