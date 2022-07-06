module BxBlockAdmin
  module V1
    class VariantsController < ApplicationController
      before_action :set_variant, only: %i(update show destroy)

      def index
        variants = BxBlockCatalogue::Variant.all
        render json: serialized_hash(variants), status: :ok
      end

      def create
        variant = BxBlockCatalogue::Variant.new(variant_params)
        if variant.save
          render json: serialized_hash(variant), status: :ok          
        else
          render json: error_serialized_hash(variant), status: :unprocessable_entity
        end
      end

      def update
        if @variant.update_attributes(variant_params)
          render json: serialized_hash(@variant), status: :ok
        else
          render json: error_serialized_hash(@variant), status: :unprocessable_entity
        end
      end

      def show
        render json: serialized_hash(@variant), status: :ok
      end

      def destroy
        if @variant.destroy
          render json: { message: "Variant deleted successfully.", success: true}, status: :ok
        else
          render json: error_serialized_hash(@variant), status: :unprocessable_entity
        end
      end

      private

        def variant_params
          params.permit(:name, variant_properties_attributes: [:id, :name, :_destroy])
        end

        def set_variant
          begin
            @variant = BxBlockCatalogue::Variant.find(params[:id])
          rescue => exception
            render json: { error: "Variant not found." }, status: :not_found
          end
        end

        # Used to serialize the variant object.
        def serialized_hash(obj, options = {})
          BxBlockAdmin::VariantSerializer.new(obj, options).serializable_hash
        end

        # Used to serialize the error object.
        def error_serialized_hash(obj)
          BxBlockCatalogue::ErrorSerializer.new(obj).serializable_hash
        end

    end
  end
end
