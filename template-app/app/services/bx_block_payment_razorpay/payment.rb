module BxBlockPaymentRazorpay
  class Payment
    class << self
      require 'razorpay'

      def create(amount, currency, receipt)
        setup_razorpay
        Razorpay::Order.create(amount: amount, currency: currency, receipt: receipt)
      end

      def verify(order_id, payment_id, signature)
        setup_razorpay
        payment_response = {
          razorpay_order_id: order_id,
          razorpay_payment_id: payment_id,
          razorpay_signature: signature
        }

        Razorpay::Utility.verify_payment_signature(payment_response)
      end

      def capture(payment_id, capture_amount, currency = 'INR')
        setup_razorpay
        Razorpay::Payment.fetch(payment_id).capture(
          amount: capture_amount,
          currency: currency
        )
      end

      def order_details(order_id)
        setup_razorpay
        Razorpay::Order.fetch(order_id)
      end

      def refund(payment_id, amount)
        setup_razorpay
        Razorpay::Payment.fetch(payment_id).refund({ amount: amount })
      end

      private

      def setup_razorpay
        razorpay_configuration = BxBlockApiConfiguration::ApiConfiguration.find_by(configuration_type: 'razorpay')
        Razorpay.setup(razorpay_configuration&.api_key, razorpay_configuration&.api_secret_key)
      end
    end
  end
end
