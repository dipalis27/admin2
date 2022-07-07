module BxBlockAdmin
  module V1
    class BrandsController < ApplicationController
      before_action :set_brand, only: %i(update show destroy)

      def index
        brands = BxBlockCatalogue::Brand.all      
        render json: serialized_hash(brands), status: :ok  
      end

      def create
        brand = BxBlockCatalogue::Brand.new(brand_params)
        if brand.save
          render json: serialized_hash(brand), status: :ok
        else
          render json: serialized_hash(brand, {}, true), status: :unprocessable_entity
        end
      end

      def update
        if @brand.update(brand_params)
          render json: serialized_hash(@brand), status: :ok
        else
          render json: serialized_hash(@brand, {}, true), status: :unprocessable_entity
        end
      end

      def show
        render json: serialized_hash(@brand), status: :ok
      end

      def destroy
        if @brand.destroy
          render json: { message: "Brand deleted successfully." }, status: :ok
        else
          render json: serialized_hash(@brand, {}, true), status: :unprocessable_entity          
        end
      end

      private

        def brand_params
          params.permit(:name)    
        end

        def set_brand
          begin
            @brand = BxBlockCatalogue::Brand.find(params[:id])
          rescue => exception
            render json: { message: "Brand not found." }, status: :not_found
          end
        end

        # Calls base class method serialized_hash in application_controller
        def serialized_hash(obj, options = {}, error = false)
          serializer_class = error ? BxBlockCatalogue::ErrorSerializer : BrandSerializer
          super(serializer_class, obj, options = {})
        end

    end
  end
end