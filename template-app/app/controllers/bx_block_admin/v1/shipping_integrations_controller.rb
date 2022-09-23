module BxBlockAdmin
  module V1
    class ShippingIntegrationsController < ApplicationController
      before_action :set_api_configuration, only: [:show, :update, :destroy]
      
      def index
        @brand =  BxBlockStoreProfile::BrandSetting.last

        if @brand.country == "india"
          if shiprocket_default_credentials_available?
            render json: shiprocket_variable_response, status: :ok
          else
            api_configuration = BxBlockApiConfiguration::ApiConfiguration.where(configuration_type:'shiprocket')
            render json: BxBlockAdmin::ApiConfigurationSerializer.new(api_configuration).serializable_hash, status: :ok
          end
        else
          api_configuration = BxBlockApiConfiguration::ApiConfiguration.where(configuration_type:'525k')
          render json: BxBlockAdmin::ApiConfigurationSerializer.new(api_configuration).serializable_hash, status: :ok
        end
      end

      def create
        api_configuration = BxBlockApiConfiguration::ApiConfiguration.new(api_configuration_params)
        if api_configuration.save
          render json: BxBlockAdmin::ApiConfigurationSerializer.new(api_configuration).serializable_hash, status: :ok
        else
          render json: {errors: [api_configuration.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end

      def update
        return render json: {errors: ['api configuration not found.']}, status: :unprocessable_entity if @api_configuration.blank?
        if @api_configuration.update(api_configuration_params)
          render json: BxBlockAdmin::ApiConfigurationSerializer.new(@api_configuration).serializable_hash, status: :ok
        else
          render json: {errors: [@api_configuration.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end

      def show
        if @api_configuration
          render json: BxBlockAdmin::ApiConfigurationSerializer.new(@api_configuration).serializable_hash, status: :ok
        else
          render json: {errors: ['api configuration not found.']}, status: :unprocessable_entity
        end
      end

      def destroy
        if @api_configuration
          @api_configuration.destroy
          render json: {message: 'Api configuration delete successfully.'}, status: :ok
        else
          render json: {errors: ['Api configuration not found.']}, status: :unprocessable_entity
        end
      end

      private
        def set_api_configuration
          @api_configuration = BxBlockApiConfiguration::ApiConfiguration.find_by_id(params[:id])
        end

        def api_configuration_params
          params.permit(:configuration_type, :ship_rocket_user_email, :ship_rocket_user_password, :oauth_site_url, :base_url, :client_id, :client_secret, :logistic_api_key)
        end

        def shiprocket_default_credentials_available?
          ENV['SHIPROCKET_EMAIL'].present? && ENV['SHIPROCKET_PASSWORD'].present?
        end

        def shiprocket_variable_response
          {
            data:[
            {
              attributes:{
                ship_rocket_user_email: ENV['SHIPROCKET_EMAIL'],
                ship_rocket_user_password: ENV['SHIPROCKET_PASSWORD'],
                configuration_type: "shiprocket",
                shiprocket_variables: shiprocket_default_credentials_available?
              }
            }
          ]
          }
        end
    end
  end
end
