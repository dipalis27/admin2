module BxBlockAdmin
  class AppSubmissionRequirementSerializer < BuilderBase::BaseSerializer
    attributes :app_name, :short_description, :description, :tags,
      :website, :email, :phone, :first_name, :last_name, :country_name, :state, :city,
      :postal_code, :address,
      :privacy_policy_url, :support_url, :marketing_url, :terms_and_conditions_url,
      :target_audience_and_content,
      :is_paid, :default_price, :distributed_countries, :auto_price_conversion,
      :android_wear, :google_play_for_education, :us_export_laws, :copyright

    attribute :app_icon do |object|
      $hostname + Rails.application.routes.url_helpers.rails_blob_url(object.app_icon, only_path: true) if object.app_icon.attached?
    end

    attribute :common_feature_banner do |object|
      $hostname + Rails.application.routes.url_helpers.rails_blob_url(object.common_feature_banner, only_path: true) if object.common_feature_banner.attached?
    end

    attribute :app_categories do |object|
      AppCategorySerializer.new(object.app_categories).serializable_hash      
    end
  end
end
