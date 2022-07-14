module BxBlockAdmin

  module V1

    class CustomerFeedbacksController < ApplicationController
      before_action :process_image, only: [:create, :update]
      
      def index
        @feedbacks = BxBlockCatalogue::CustomerFeedback.all 
        
        if @feedbacks.present?
          @feedbacks = @feedbacks.order(created_at: "desc").page(params[:page]).per(10)
          render json: @feedbacks, status: :ok
        else
          render json: { message: "No feedbacks found"}, status: 404
        end
      end

      def create
        @feedback = BxBlockCatalogue::CustomerFeedback.new(feedback_params)
        @feedback = attach_image(@feedback, image_param[:image], 'feedback pic')if image_param.present?

        if @feedback.save
          render json: CustomerFeedbackSerializer.new(@feedback).serializable_hash, status: :ok
        else
          render json: { errors:@feedback.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        begin
         @feedback = BxBlockCatalogue::CustomerFeedback.find(params[:id])
          render json:@feedback, status: :ok
        rescue 
          render(json: { error: "No feedback found" }, status:404)
        end
      end

      def update
       @feedback = BxBlockCatalogue::CustomerFeedback.find(params[:id])
       @feedback = attach_image(@feedback, image_param[:image], 'feedback pic')if image_param.present?

        if @feedback.update(feedback_params)
          render json: CustomerFeedbackSerializer.new(@feedback).serializable_hash,  message: "Feedback updated successfully", status: :ok
        else
          render(json:{ error: "No feedback found"}, status:404)
        end
      end

      def destroy
       @feedback = BxBlockCatalogue::CustomerFeedback.find(params[:id])

        if @feedback.destroy
          render json: { message: "Feedback deleted successfully", success: true}, status: :ok
        else
          render json: {message: "No feedback found", success:false}, status: :unprocessable_entity
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
        params.permit(:title, :description, :position, :customer_name, :catalogue_id, :is_active)
      end

      def image_param
        params.permit(:image)
      end

    end
  end
end
