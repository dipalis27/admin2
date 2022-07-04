module BxBlockAdmin

  module V1

    class TaxesController < ApplicationController
      
      def index
        @taxes = BxBlockOrderManagement::Tax.all

        if @taxes.present?
          render json: @taxes, status: :ok
        else
          render json: { message: "No tax found"}, status: 404
        end
      end

      def create
        @tax = BxBlockOrderManagement::Tax.create(tax_params)

        if @tax.save
          render json: @tax, status: :ok
        else
          render json: { errors: @tax.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        begin
          @tax = BxBlockOrderManagement::Tax.find(params[:id])
          render json: @tax, status: :ok
        rescue 
          render(json: { error: "No taxes found" }, status:404)
        end
      end

      private

      def tax_params
        params.permit(:tax_percentage)
      end
    end
    
  end
  
end
