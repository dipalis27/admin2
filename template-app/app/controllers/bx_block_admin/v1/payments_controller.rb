module BxBlockAdmin

  module V1

    class PaymentsController < ApplicationController
      before_action :set_api, only:[:show, :update]
      before_action :check_api_configuration, only: :index
      def index
        api = @brand.country == "india"? BxBlockApiConfiguration::ApiConfiguration.find_by(configuration_type: "razorpay"): BxBlockApiConfiguration::ApiConfiguration.find_by(configuration_type: "stripe")

        if api.present?
          render json: PaymentSerializer.new(api).serializable_hash, success: :ok
        else
          render json:{error:"No API configurations found"}, status: 200
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
          render json: {
            data:{
              attributes:{
                api_key: ENV['RAZORPAY_KEY'],
                user_name: ENV['USER_NAME'],
                api_secret_key: '-',
                razorpay_account_id: ENV['RAZORPAY_ACCOUNT_ID'],
                razorpay_variables: (ENV['RAZORPAY_KEY'] && ENV['RAZORPAY_SECRET']).present?
              }
            }
          }
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

      def check_api_configuration
        @brand =  BxBlockStoreProfile::BrandSetting.last
        
        if @brand.country == "india" && !BxBlockApiConfiguration::ApiConfiguration.find_by(configuration_type: "razorpay").present?
          BxBlockApiConfiguration::ApiConfiguration.find_or_create_by(configuration_type: "razorpay", api_key: "n/a", api_secret_key: "n/a")
        elsif @brand.country == "uk" && !BxBlockApiConfiguration::ApiConfiguration.find_by(configuration_type: "stripe").present?
          BxBlockApiConfiguration::ApiConfiguration.find_or_create_by(configuration_type: "stripe", api_key: "n/a", api_secret_key: "n/a")
        end
      end
      
    end
  end
end
