module BxBlockAdmin

  module V1

    class PaymentsController < ApplicationController
      before_action :set_api, only:[:show, :update]

      def index
        @apis = BxBlockApiConfiguration::ApiConfiguration.all
        
        if @apis.present?
          render json: PaymentSerializer.new(@apis).serializable_hash, success: :ok
        else
          render(json:{error:"No API configurations found"}, status: 404)
        end
      end

      def create
        @api = BxBlockApiConfiguration::ApiConfiguration.create(api_params)

        if @api.save
          render json: PaymentSerializer.new(@api).serializable_hash, success: :ok
        else
          render(json:{error:@api.errors}, status: :unprocessable_entity)
        end
      end
      
      def show
        render json: PaymentSerializer.new(@api).serializable_hash, success: :ok
      end

      def update
        if @api.update(api_params)
          render json: PaymentSerializer.new(@api).serializable_hash, status: :ok
        else
          render json: {"errors": @api.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def get_status
        if (ENV['RAZORPAY_KEY'] && ENV['RAZORPAY_SECRET']).present?
          begin
            url = URI("https://staging.cloud-marketplace.builder.ai/api/accounts/#{ENV['RAZORPAY_ACCOUNT_ID']}")
            http = Net::HTTP.new(url.host, url.port);
            http.use_ssl = true
            request = Net::HTTP::Get.new(url)
            request.basic_auth 'local_cat', 'password'
            response = http.request request
            live_status = JSON.parse(response.body)["data"]["live_status"]
            render json: {api_key: ENV['RAZORPAY_KEY'], api_secret_key: ENV['RAZORPAY_SECRET'], live_status: live_status}, status: :ok
          rescue 
            render json: {api_key: ENV['RAZORPAY_KEY'], api_secret_key: ENV['RAZORPAY_SECRET'], live_status: "Not Activated"}, status: :ok
          end
        else
          razorpay = BxBlockApiConfiguration::ApiConfiguration.find_by(configuration_type: "razorpay")
          render json: PaymentSerializer.new(razorpay).serializable_hash, status: :ok
        end
      end

      private

      def api_params
        params.permit(:id, :configuration_type, :api_key, :api_secret_key)
      end

      def set_api
        begin
          @api = BxBlockApiConfiguration::ApiConfiguration.find(api_params[:id])
        rescue 
          render json: {"errors": "API configuration not found"}, status: 404
        end
      end
    end
  end
end
