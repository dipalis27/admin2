module BxBlockAdmin
  class PaymentSerializer < BuilderBase::BaseSerializer
    attributes :id, :configuration_type, :api_key, :api_secret_key, :razorpay_account_id, :razorpay_variables

    attribute :razorpay_account_id do
      ENV['RAZORPAY_ACCOUNT_ID']
    end 

    attribute :razorpay_variables do
      (ENV['RAZORPAY_KEY'] && ENV['RAZORPAY_SECRET']).present?
    end 
  end
end
