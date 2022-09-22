module BxBlockAdmin

  module V1

    class PaymentsController < ApplicationController
      before_action :set_api, only:[:show, :update]

      def index
        brand =  BxBlockStoreProfile::BrandSetting.last

        if brand.country == "india"
          if razorpay_default_credentials_available?
            render json: razorpay_variable_response, status: :ok
          else
            api = BxBlockApiConfiguration::ApiConfiguration.where(configuration_type:'razorpay')
            render json: PaymentSerializer.new(api).serializable_hash, success: :ok
          end
        else
          api = BxBlockApiConfiguration::ApiConfiguration.find_by(configuration_type: "stripe")
          render json: PaymentSerializer.new(api).serializable_hash, success: :ok
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

      def razorpay_default_credentials_available?
        ENV['RAZORPAY_KEY'].present? && ENV['RAZORPAY_SECRET'].present?
      end

      def razorpay_variable_response
        {data:{
            attributes:{
              api_key: ENV['RAZORPAY_KEY'],
              user_name: ENV['USER_NAME'],
              api_secret_key: '-',
              razorpay_account_id: ENV['RAZORPAY_ACCOUNT_ID'],
              configuration_type: "razorpay",
              razorpay_variables: razorpay_default_credentials_available?
            }
          }
        }
      end
    end
  end
end
