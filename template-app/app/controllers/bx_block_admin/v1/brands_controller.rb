module BxBlockAdmin
  module V1
    class BrandsController < ApplicationController
      rescue_from ActiveRecord::InvalidForeignKey, with: :foreign_key_violation
      before_action :set_brand, only: %i(update show destroy)

      def index
        per_page = get_per_page_count
        current_page = params[:page].present? ? params[:page].to_i : 1
        brands = BxBlockCatalogue::Brand.order(id: :desc).page(current_page).per(per_page)
        options = {}
        options[:meta] = {
          pagination: {
            current_page: brands.current_page,
            next_page: brands.next_page,
            prev_page: brands.prev_page,
            total_pages: brands.total_pages,
            total_count: brands.total_count
          }
        }      
        render json: serialized_hash(brands, options: options), status: :ok  
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

        # Returns the count that are required for listing the records.
        def get_per_page_count
          return 10 unless params[:per_page].present?
          return BxBlockCatalogue::Brand.count if params[:per_page] == "all"
          params[:per_page].to_i
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