module BxBlockAdmin
  module V1
    class CustomerFeedbacksController < ApplicationController
      before_action :process_image, only: [:create, :update]
      before_action :set_feedback, only: [:show, :update, :destroy]
      
      def index
        per_page = params[:per_page].present? ? params[:per_page].to_i : 10
        current_page = params[:page].present? ? params[:page].to_i : 1
        feedbacks = BxBlockCatalogue::CustomerFeedback.order(created_at: :desc).page(current_page).per(per_page)
        if params[:search].present?
          feedbacks = BxBlockCatalogue::CustomerFeedback.where("customer_name ILIKE (?) or description ILIKE (?)", "%#{params[:search]}%", "%#{params[:search]}%").page(current_page).per(per_page)
        else
          feedbacks = BxBlockCatalogue::CustomerFeedback.all.order(created_at: :desc).page(current_page).per(per_page)
        end
        render json: CustomerFeedbackSerializer.new(feedbacks, pagination_data(feedbacks, per_page)).serializable_hash, status: :ok
      end

      def create
        @feedback = BxBlockCatalogue::CustomerFeedback.new(feedback_params)
        if image_param.present?
          image_path, image_extension = store_base64_image(image_param[:image])
          @feedback.image.attach(io: File.open(image_path), filename: "feedback pic.#{image_extension}")
          File.delete(image_path) if File.exist?(image_path)
        end

        if @feedback.save
          render json: CustomerFeedbackSerializer.new(@feedback).serializable_hash, status: :ok
        else
          render json: { errors:@feedback.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: CustomerFeedbackSerializer.new(@feedback).serializable_hash, status: :ok
      end

      def update
        if image_param.present?
          image_path, image_extension = store_base64_image(image_param[:image])
          @feedback.image.attach(io: File.open(image_path), filename: "feedback pic.#{image_extension}")
          File.delete(image_path) if File.exist?(image_path)
        end
        @feedback.assign_attributes(feedback_params)
        if @feedback.save
          render json: CustomerFeedbackSerializer.new(@feedback).serializable_hash,  message: "Feedback updated successfully", status: :ok
        else
          render json: {"errors": @feedback.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def destroy
        if @feedback.destroy
          render json: { message: "Feedback deleted successfully", success: true}, status: :ok
        else
          render json: {"errors": @feedback.errors.full_messages}, status: :unprocessable_entity
        end
      end

      private
      
      def process_image
        return if params[:image].blank?

        if !(BxBlockCatalogue::CustomerFeedback::VALID_IMAGE_FORMATS).any?{|valid_ext|params[:image].include?(valid_ext)}
          render json: { errors: ["invalid image format"] }, status: :unprocessable_entity
        end
      end

      def feedback_params
        params.permit(:id, :title, :description, :position, :customer_name, :catalogue_id, :is_active)
      end

      def image_param
        params.permit(:image)
      end

      def set_feedback
        begin
          @feedback = BxBlockCatalogue::CustomerFeedback.find(feedback_params[:id])
        rescue 
          render json: { 'error': 'Customer feedback not found' }, status: :not_found
        end
      end
    end
  end
end
