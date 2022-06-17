module BxBlockAdmin
  module V1
    class CataloguesController < ApplicationController
      before_action :set_catalogue, only: [:show, :update, :destroy]

      def index
        per_page = params[:per_page].present? ? params[:per_page].to_i : 10
        current_page = params[:page].present? ? params[:page].to_i : 1
        catalogues = BxBlockCatalogue::Catalogue.order(created_at: :desc).page(current_page).per(per_page)
        options = {}
        options[:meta] = {
          pagination: {
            current_page: catalogues.current_page,
            next_page: catalogues.next_page,
            prev_page: catalogues.prev_page,
            total_pages: catalogues.total_pages,
            total_count: catalogues.total_count
          }
        }
        render json: BxBlockAdmin::CatalogueSerializer.new(catalogues, options).serializable_hash, status: :ok
      end

      def create
        catalogue = BxBlockCatalogue::Catalogue.new(catalogue_params) 
        if catalogue.save
          assign_sub_categories(catalogue)
          render json: BxBlockAdmin::CatalogueSerializer.new(catalogue).serializable_hash, status: :ok
        else 
          render json: BxBlockCatalogue::ErrorSerializer.new(catalogue).serializable_hash, status: :unprocessable_entity
        end
      end

      def show
        render json: BxBlockAdmin::CatalogueSerializer.new(@catalogue).serializable_hash, status: :ok
      end

      def update
        if @catalogue.update_attributes(catalogue_params)
          assign_sub_categories(@catalogue)
          render json: BxBlockAdmin::CatalogueSerializer.new(@catalogue).serializable_hash, status: :ok
        else
          render json: BxBlockCatalogue::ErrorSerializer.new(@catalogue).serializable_hash, status: :unprocessable_entity
        end
      end

      def destroy
        if @catalogue.destroy
          render json: { message: "Product deleted successfully.", success: true}, status: :ok
        else
          render json: BxBlockCatalogue::ErrorSerializer.new(@catalogue).serializable_hash, status: :unprocessable_entity
        end
      end

      private

        def toggle_params
          params.permit(:id, :active)
        end

        def catalogue_params
          params.permit(:brand_id, :name, :sku, :description, :manufacture_date, :length, :breadth, :height, :availability, :stock_qty, :weight, :price, :recommended, :on_sale, :sale_price, :discount, :block_qty, :sold, :available_price, :status, :tax_amount, :price_including_tax, :tax_id, tag_ids: [], attachments_attributes: [:id, :cropped_image, :is_default, :_destroy], catalogue_variants_attributes: [:id, :price, :stock_qty, :on_sale, :sale_price, :discount_price, :tax_id, :tax_amount, :length, :breadth, :height, :block_qty, :is_default, :_destroy, catalogue_variant_properties_attributes: [:id, :variant_id, :variant_property_id], attachments_attributes: [:id, :cropped_image, :is_default, :_destroy]], catalogue_subscriptions_attributes: [:subscription_package, :subscription_period, :discount, :morning_slot, :evening_slot])
        end

        def set_catalogue
          @catalogue = BxBlockCatalogue::Catalogue.find(params[:id])
        end

        def assign_sub_categories(catalogue)
          if params[:sub_category_ids]
            catalogue.sub_categories = BxBlockCategoriesSubCategories::SubCategory.where(id: params[:sub_category_ids])
            catalogue.save
          end
        end

    end
  end
end
