module BxBlockAdmin
  class PaymentSerializer < BuilderBase::BaseSerializer
    attributes :id, :configuration_type, :api_key, :api_secret_key, :razorpay_account_id

    attribute :razorpay_account_id do
      ENV['RAZORPAY_ACCOUNT_ID']
    end 
  end
end
