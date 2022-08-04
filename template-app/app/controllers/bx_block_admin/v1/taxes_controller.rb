module BxBlockAdmin
  module V1
    class TaxesController < ApplicationController
      before_action :set_tax, only: %i(show)

      def index
        taxes = BxBlockOrderManagement::Tax.order(id: :desc).page(params[:page]).per(params[:per_page])
        render json: serialized_hash(taxes, options: pagination_data(taxes, params[:per_page])), status: :ok
      end

      def create
        tax = BxBlockOrderManagement::Tax.new(tax_params)
        if tax.save
          render json: serialized_hash(tax), status: :ok
        else
          render json: { errors: tax.errors.full_messages }, status: :unprocessable_entity    
        end
      end

      def show
        render json: serialized_hash(@tax), status: :ok
      end

      private

      def tax_params
        params.permit(:tax_percentage)
      end

      def set_tax
        begin
          @tax = BxBlockOrderManagement::Tax.find(params[:id])
        rescue => exception
          render json: { errors: ["Tax not found."] }, status: :not_found
        end
      end

      # Calls base class method serialized_hash in application_controller
      def serialized_hash(obj, options: {}, serializer_class: BxBlockAdmin::TaxSerializer)
        super(serializer_class, obj, options)
      end
    end
  end
end
