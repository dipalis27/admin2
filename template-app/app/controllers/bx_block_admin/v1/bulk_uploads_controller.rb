module BxBlockAdmin
  module V1
    class BulkUploadsController < ApplicationController
      before_action :set_bulk_image, only: [:show, :destroy]

      def index
        per_page = params[:per_page].present? ? params[:per_page].to_i : 10
        current_page = params[:page].present? ? params[:page].to_i : 1
        bulk_images = BxBlockCatalogue::BulkImage.order(updated_at: :desc).page(current_page).per(per_page)
        render json: BxBlockAdmin::BulkImageSerializer.new(bulk_images, pagination_data(bulk_images, per_page)).serializable_hash, status: :ok
      end

      def create
        if bulk_image_params[:images].blank?
          return render json: {errors: ["Image can't be blank. Upload at one image."]}, status: :unprocessable_entity
        elsif file_is_large?
          return render json: {errors: ["Total file size is exceeded. Total file size should be less than 50 MB per upload"]}, status: :unprocessable_entity
        elsif bulk_image_params[:images].present?
          response = BxBlockCatalogue::BulkImage.validate_and_save(bulk_image_params[:images])
          if response[:success]
            render json: { 'messages': [response[:message]] }, status: :ok
          else
            return render json: {errors: [response[:message]]}, status: :unprocessable_entity
          end
        end
      end

      def show
        if @bulk_image
          render json: BxBlockAdmin::BulkImageSerializer.new(@bulk_image), status: :ok
        else
          return render json: {errors: ["Image not found"]}, status: :unprocessable_entity
        end
      end

      def destroy
        if @bulk_image
          @bulk_image.destroy
          render json: { 'messages': ["Image deleted successfully."] }, status: :ok
        else
          return render json: {errors: ["Image not found"]}, status: :unprocessable_entity
        end
      end

      private

        def bulk_image_params
          params.permit(images: [])
        end

        def set_bulk_image
          @bulk_image = BxBlockCatalogue::BulkImage.find_by_id(params[:id])
        end

        def file_is_large?
          images = params[:images]
          file_size = 0
          images.each do |image|
            tempfilepath = image.tempfile.path
            image_size = File.size(tempfilepath)
            file_size = file_size + image_size
          end
          if file_size > 50.megabytes
            true
          else
            false
          end
        end
    end
  end
end
