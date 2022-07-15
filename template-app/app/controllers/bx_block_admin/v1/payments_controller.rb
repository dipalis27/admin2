module BxBlockAdmin

  module V1

    class PaymentsController < ApplicationController
      
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
        begin
          @api = BxBlockApiConfiguration::ApiConfiguration.find(params[:id])
          render json: PaymentSerializer.new(@api).serializable_hash, success: :ok
        rescue 
          render(json: { error: "No API configuration found" }, status:404)
        end
      end

      def update
        @api = BxBlockApiConfiguration::ApiConfiguration.find(params[:id])

        if @api.update(api_params)
          render json: { data: PaymentSerializer.new(@api).serializable_hash, message: "API Configuration updated successfully"}, status: 200
        else
          render json: {errors: "API configuration not found"}, status: :not_found
        end
      end

      private

      def api_params
        params.permit(:configuration_type, :api_key, :api_secret_key)
      end
    end
  end
end
