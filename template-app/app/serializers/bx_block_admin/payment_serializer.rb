module BxBlockAdmin
  class PaymentSerializer < BuilderBase::BaseSerializer
    attributes :id, :configuration_type, :api_key, :api_secret_key
  end
end
