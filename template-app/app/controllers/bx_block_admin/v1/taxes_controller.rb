module BxBlockAdmin
  module V1
    class TaxesController < ApplicationController
      before_action :set_tax, only: %i(edit update show destroy)

      def index
        taxes = BxBlockOrderManagement::Tax.order(:id).all
        render json: serialized_hash(taxes), status: :ok
      end

      def create
        tax = BxBlockOrderManagement::Tax.new(tax_params)
        if tax.save
          render json: serialized_hash(tax), status: :ok
        else
          render json: { errors: tax.errors.full_messages }, status: :unprocessable_entity    
        end
      end

      def edit
        render json: serialized_hash(@tax), status: :ok
      end

      def update
        if @tax.update(tax_params)
          render json: serialized_hash(@tax), status: :ok
        else
          render json: { errors: @tax.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: serialized_hash(@tax), status: :ok
      end

      def destroy
        if @tax.destroy
          render json: { message: "Tax deleted successfully." }, status: :ok
        else
          render json: { errors: @tax.errors.full_messages }, status: :unprocessable_entity
        end
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