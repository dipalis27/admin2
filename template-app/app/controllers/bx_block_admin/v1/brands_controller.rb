module BxBlockAdmin
  module V1
    class BrandsController < ApplicationController
      rescue_from ActiveRecord::InvalidForeignKey, with: :foreign_key_violation
      before_action :set_brand, only: %i(update show destroy)

      def index
        brands = BxBlockCatalogue::Brand.order(id: :desc).page(params[:page]).per(params[:per_page])
        render json: serialized_hash(brands, options: pagination_data(brands, params[:per_page])), status: :ok  
      end

      def create
        brand = BxBlockCatalogue::Brand.new(brand_params)
        if brand.save
          render json: serialized_hash(brand), status: :ok
        else
          render json: { errors: brand.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @brand.update(brand_params)
          render json: serialized_hash(@brand), status: :ok
        else
          render json: { errors: @brand.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: serialized_hash(@brand), status: :ok
      end

      def destroy
        if @brand.destroy
          render json: { message: "Brand deleted successfully." }, status: :ok
        else
          render json: { errors: @brand.errors.full_messages }, status: :unprocessable_entity          
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
            render json: { errors: ["Brand not found."] }, status: :not_found
          end
        end

        # Calls base class method serialized_hash in application_controller
        def serialized_hash(obj, options: {}, serializer_class: BxBlockAdmin::BrandSerializer)
          super(serializer_class, obj, options)
        end

        def foreign_key_violation(exception)
          if exception.message.include?("catalogues")
            render json: { errors: "Unable to delete, products exists with the brand." }, status: :unprocessable_entity
          else
            render json: { errors: exception.message }, status: :unprocessable_entity  
          end  
        end

    end
  end
end