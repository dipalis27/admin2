module BxBlockAdmin
  module V1
    class TaxesController < ApplicationController
      before_action :set_tax, only: %i(show)

      def index
        per_page = params[:per_page].present? ? params[:per_page].to_i : 10
        current_page = params[:page].present? ? params[:page].to_i : 1
        taxes = BxBlockOrderManagement::Tax.order(:id).page(current_page).per(per_page)
        options = {}
        options[:meta] = {
          pagination: {
            current_page: taxes.current_page,
            next_page: taxes.next_page,
            prev_page: taxes.prev_page,
            total_pages: taxes.total_pages,
            total_count: taxes.total_count
          }
        }
        render json: serialized_hash(taxes, options: options), status: :ok
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
