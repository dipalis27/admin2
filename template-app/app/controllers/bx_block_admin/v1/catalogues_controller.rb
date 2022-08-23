module BxBlockAdmin
  module V1
    class CataloguesController < ApplicationController
      before_action :set_catalogue, only: [:show, :update, :destroy]

      def index
        per_page = params[:per_page].present? ? params[:per_page].to_i : 10
        current_page = params[:page].present? ? params[:page].to_i : 1
        if params[:search].present? || params[:filters].present?
          catalogue_array = BxBlockCatalogue::Catalogue.search(params)
          catalogues = Kaminari.paginate_array(catalogue_array).page(current_page).per(per_page)
        else
          catalogues = BxBlockCatalogue::Catalogue.order(updated_at: :desc).page(current_page).per(per_page)  
        end
        render json: serialized_hash(catalogues, options: pagination_data(catalogues, per_page)), status: :ok
      end

      def create
        catalogue = BxBlockCatalogue::Catalogue.new(catalogue_params) 
        if catalogue.save
          assign_sub_categories(catalogue)
          render json: serialized_hash(catalogue), status: :ok
        else 
          render json: { errors: catalogue.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: serialized_hash(@catalogue), status: :ok
      end

      def update
        if @catalogue.update_attributes(catalogue_params)
          assign_sub_categories(@catalogue)
          render json: serialized_hash(@catalogue), status: :ok
        else
          render json: { errors: @catalogue.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        order_item_exist = @catalogue.order_items.present?
        if order_item_exist
          @catalogue.update_column(status: 'draft')
          render json: { message: "You can't delete this product because few orders are associated with this product. The product's status has been changed to Draft.", success: true}, status: :ok
        elsif @catalogue.destroy
          render json: { message: "Product deleted successfully.", success: true}, status: :ok
        else
          render json: { errors: @catalogue.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def download_sample_csv
        render json: { csv_data: BxBlockCatalogue::Catalogue.generate_sample_csv }, status: :ok
      end

      def upload_csv
        if params[:upload_csv]
          if params[:upload_csv].content_type.include?("csv")
            csv_errors = {}
            count, csv_errors = CsvDb.convert_save("BxBlockCatalogue::Catalogue", params[:upload_csv])

            success_message = "#{count} products uploaded/updated successfully. \n"
            error_message = nil
            if csv_errors.present?
              error_message = "CSV has error(s) on: \n"
              csv_errors.each do |error|
                error_message += error[0] + error[1].join(", ")
              end
            end

            if count > 0
              render json: { message: success_message, errors: error_message }, status: :ok
            else
              render json: { errors: error_message }, status: :ok
            end
          else
            render json: { errors: "File format not valid!" }, status: :unprocessable_entity
          end
        else
          render json: { errors: "Please select a file" }, status: :unprocessable_entity
        end
      end

      def bulk_delete
        begin
          catalogues = BxBlockCatalogue::Catalogue.find(params[:ids])
          if catalogues.present?
            catalogues.map(&:destroy)
            render json: { message: "Products deleted successfully.", success: true}, status: :ok  
          else
            render json: { errors: ["Products not found."] }, status: :not_found  
          end
        rescue => exception
          render json: { errors: ["Products not found."] }, status: :not_found
        end
      end
      
      private

        def toggle_params
          params.permit(:id, :active)
        end

        def catalogue_params
          params.permit(:brand_id, :name, :sku, :description, :manufacture_date, :length, :breadth, :height, :stock_qty, :weight, :price, :recommended, :on_sale, :sale_price, :discount, :block_qty, :sold, :status, :tax_id, tag_ids: [], attachments_attributes: [:id, :cropped_image, :is_default, :_destroy], catalogue_variants_attributes: [:id, :price, :stock_qty, :on_sale, :sale_price, :discount_price, :tax_id, :tax_amount, :length, :breadth, :height, :block_qty, :is_default, :_destroy, catalogue_variant_properties_attributes: [:id, :variant_id, :variant_property_id, :_destroy], attachments_attributes: [:id, :cropped_image, :is_default, :_destroy]], catalogue_subscriptions_attributes: [:subscription_package, :subscription_period, :discount, :morning_slot, :evening_slot])
        end

        def set_catalogue
          begin
            @catalogue = BxBlockCatalogue::Catalogue.find(params[:id])
          rescue => exception
            render json: { errors: ["Product not found."] }, status: :not_found
          end
        end

        def assign_sub_categories(catalogue)
          if params[:sub_category_ids]
            catalogue.sub_categories = BxBlockCategoriesSubCategories::SubCategory.where(id: params[:sub_category_ids])
            catalogue.save
          end
        end

        # Calls base class method serialized_hash in application_controller
        def serialized_hash(obj, options: {}, serializer_class: BxBlockAdmin::CatalogueSerializer)
          super(serializer_class, obj, options)
        end

    end
  end
end
