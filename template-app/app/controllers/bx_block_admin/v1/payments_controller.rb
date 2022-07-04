module BxBlockAdmin

  module V1

    class PaymentsController < ApplicationController
      
      def index
        @apis = BxBlockApiConfiguration::ApiConfiguration.all
        
        if @apis.present?
          render json: @apis, success: :ok
        else
          render(json:{error:"No promo code found"}, status: 404)
        end
      end

      def create
        @api = BxBlockApiConfiguration::ApiConfiguration.create(api_params)

        if @api.save
          render json: @api, success: :ok
        else
          render(json:{error:@api.errors}, status: :unprocessable_entity)
        end
      end
      
      def show
        @api = BxBlockApiConfiguration::ApiConfiguration.find(params[:id])

        if @api.present?
          render json: @api, success: :ok
        else
          render(json:{error: "No promo code found"}, status: 404)
        end
      end

      def update
        @api = BxBlockApiConfiguration::ApiConfiguration.update(api_params)

        if @api.present?
          render(json: @api, success: :ok, message: "Promo code updated successfully")
        else
          render(json:{error: "No promo code found"}, status: 404)
        end
      end

      def destroy
        @api = BxBlockApiConfiguration::ApiConfiguration.find(params[:id])

        if @api.destroy
          render json: {messages: "Promo code destroyed successfully"}, status: :ok
        else
          render(json:{ error: "No promo code found"}, status:404)
        end
      end

      private

      def api_params
        params.permit()
      end
    end
  end
end
