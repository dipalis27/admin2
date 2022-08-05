module BxBlockAdmin
  module V1
    class VariantsController < ApplicationController
      before_action :set_variant, only: %i(update show destroy)

      def index
        variants = BxBlockCatalogue::Variant.order(updated_at: :desc).page(params[:page]).per(params[:per_page])
        render json: serialized_hash(variants), status: :ok
      end

      def create
        variant = BxBlockCatalogue::Variant.new(variant_params)
        if variant.save
          render json: serialized_hash(variant), status: :ok          
        else
          render json: { errors: variant.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @variant.update(variant_params)
          render json: serialized_hash(@variant), status: :ok
        else
          render json: { errors: @variant.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: serialized_hash(@variant), status: :ok
      end

      def destroy
        if @variant.destroy
          render json: { message: "Variant deleted successfully.", success: true }, status: :ok
        else
          render json: { errors: @variant.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def bulk_data
        data = bulk_data_params
        variants = []
        # Validates the variant hash with variant_properties
        data.each do |variant_hash|
          unless variant_hash.has_key?(:id)
            if variant_hash[:variant_properties_attributes].nil?
              render json: { error: "#{variant_hash[:name]} should have atleast one variant property."}, status: :unprocessable_entity and return
            end
          end
        end
        data.each do |variant_hash|
          if variant_hash.has_key?(:id)
            variant = BxBlockCatalogue::Variant.find(variant_hash[:id])
            variant_properties_hash = variant_hash.dig(:variant_properties_attributes)
            if variant_properties_hash
              variant_properties = []
              variant_properties_hash.each do |variant_property_hash|
                if variant_property_hash.has_key?(:id)
                  variant_property = BxBlockCatalogue::VariantProperty.find(variant_property_hash[:id])
                  existing_variant_property = { id: variant_property.id, name: variant_property.name }
                  existing_variant_property.merge!(_destroy: variant_property_hash[:_destroy]) if variant_property_hash.has_key?(:_destroy)
                  variant_properties << existing_variant_property  
                else
                  variant_property = variant.variant_properties.find_by(name: variant_property_hash[:name])
                  if variant_property
                    existing_variant_property = { id: variant_property.id, name: variant_property.name }
                    variant_properties << existing_variant_property
                  else
                    new_variant_property_hash = { name: variant_property_hash[:name] }
                    variant_properties << new_variant_property_hash
                  end
                end
              end
              variant.update(variant_properties_attributes: variant_properties)
            end
            variants << variant
          else
            variant = BxBlockCatalogue::Variant.new(name: variant_hash[:name])
            variant_properties_hash = variant_hash.dig(:variant_properties_attributes)
            if variant_properties_hash
              # Because variant must have atleast one property, otherwise variant should not be saved.
              variant_properties_hash = variant_properties_hash.map{|variant_property_params| variant_property_params.permit(:name) }
              variant.variant_properties.build(variant_properties_hash)
              variants << variant if variant.save
            end
          end
        end
        render json: serialized_hash(variants), status: :ok
      end

      private

        def variant_params
          params.permit(:name, variant_properties_attributes: [:id, :name, :_destroy])
        end

        def set_variant
          begin
            @variant = BxBlockCatalogue::Variant.find(params[:id])
          rescue => exception
            render json: { error: ["Variant not found."] }, status: :not_found
          end
        end

        # Used for bulk creation and updation at a time.
        def bulk_data_params
          params.require(:data)
        end

        # Calls base class method serialized_hash in application_controller
        def serialized_hash(obj, options: {}, serializer_class: BxBlockAdmin::VariantSerializer)
          super(serializer_class, obj, options)
        end

    end
  end
end
