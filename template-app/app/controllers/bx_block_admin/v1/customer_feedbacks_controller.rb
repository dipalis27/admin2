module BxBlockAdmin

  module V1

    class CustomerFeedbacksController < ApplicationController
      
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
       @feedback = BxBlockCatalogue::CustomerFeedback.create(feedback_params)

        if @feedback.save
          render json:@feedback, status: :ok
        else
          render json: { errors:@feedback.errors.full_messages }, status: 400
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

        if @feedback.update(feedback_params)
          render json: { data:@feedback,  message: "Feedback updated successfully" }, status: :ok
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

      def feedback_params
        params.permit(:title, :description, :position, :customer_name, :catalogue_id, :is_active)
      end
    end
  end
end
