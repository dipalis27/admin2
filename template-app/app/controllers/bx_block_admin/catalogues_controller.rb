module BxBlockAdmin
  class CataloguesController < ApplicationController
    before_action :set_catalogue, only: [:show]

    def toggle_status
      catalogue = BxBlockCatalogue::Catalogue.find_by_id(toggle_params[:id])
      return if catalogue.nil?

      if toggle_params[:active] == 'true'
        catalogue.update(status: 'active')
      elsif toggle_params[:active] == 'false'
        catalogue.update(status: 'draft')
      end

      render json: { active: catalogue.reload.active?, success: !catalogue.errors.any?, id: catalogue.id }
    end

    def create
      catalogue = BxBlockCatalogue::Catalogue.new(catalogue_params)
      if catalogue.save
        render json: BxBlockAdmin::CatalogueSerializer.new(catalogue).serializable_hash, status: :ok
      else 
        render json: BxBlockCatalogue::ErrorSerializer.new(catalogue).serializable_hash, status: :unprocessable_entity
      end
    end

    def show
      render json: BxBlockAdmin::CatalogueSerializer.new(@catalogue).serializable_hash, status: :ok
    end

    private

      def toggle_params
        params.permit(:id, :active)
      end

      def catalogue_params
        params.permit(:brand_id, :name, :sku, :description, :manufacture_date, :length, :breadth, :height, :availability, :stock_qty, :weight, :price, :recommended, :on_sale, :sale_price, :discount, :block_qty, :sold, :available_price, :status, :tax_amount, :price_including_tax, :tax_id, sub_category_ids: [], tag_ids: [], attachments_attributes: [:id, :cropped_image, :is_default, :_destroy], catalogue_variants_attributes: [:id, :price, :stock_qty, :on_sale, :sale_price, :discount_price, :tax_id, :tax_amount, :length, :breadth, :height, :block_qty, :is_default, :_destroy, catalogue_variant_properties_attributes: [:id, :variant_id, :variant_property_id], attachments_attributes: [:id, :cropped_image, :is_default, :_destroy]])
      end

      def set_catalogue
        @catalogue = BxBlockCatalogue::Catalogue.find(params[:id])
      end

  end
end
