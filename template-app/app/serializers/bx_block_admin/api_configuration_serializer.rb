module BxBlockAdmin
  class ApiConfigurationSerializer < BuilderBase::BaseSerializer
    attributes :id, :configuration_type, :ship_rocket_user_email, :ship_rocket_user_password, :oauth_site_url, :base_url, :client_id, :client_secret, :logistic_api_key

    attribute :shiprocket_variables do
      ENV['SHIPROCKET_EMAIL'].present? && ENV['SHIPROCKET_PASSWORD'].present?
    end
  end
end