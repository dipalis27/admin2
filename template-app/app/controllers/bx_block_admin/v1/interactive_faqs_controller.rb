module BxBlockAdmin

  module V1

    class InteractiveFaqsController < ApplicationController
      
      def index
        @faqs = BxBlockInteractiveFaqs::InteractiveFaqs.all
        @faqs = @faqs.order(created_at: "desc").page(params[:page]).per(10)

        if @faqs.present?
          render json: @faqs, status: :ok
        else
          render json: { message: "No FAQ found"}, status: 404
        end
      end

      def create
        @faq = BxBlockInteractiveFaqs::InteractiveFaqs.create(faq_params)

        if @faq.save
          render json: @faq, status: :ok
        else
          render json: { errors: @faq.errors.full_messages }, status: 400
        end
      end

      def show
        begin
          @faq = BxBlockInteractiveFaqs::InteractiveFaqs.find(params[:id])
          render json: @faq, status: :ok
        rescue 
          render(json: { error: "No FAQ found" }, status:404)
        end
      end

      def update
        @faq = BxBlockInteractiveFaqs::InteractiveFaqs.find(params[:id])

        if @faq.update(faq_params)
          render json: { data: @faq,  message: "FAQ updated successfully" }, status: :ok
        else
          render(json:{ error: "No FAQ found"}, status:404)
        end
      end

      def destroy
        @faq = BxBlockInteractiveFaqs::InteractiveFaqs.find(params[:id])

        if @faq.destroy
          render json: { message: "FAQ deleted successfully.", success: true}, status: :ok
        else
          render json: {message: "No FAQ found", success:false}, status: :unprocessable_entity
        end
      end

      private

      def faq_params
        params.permit(:title, :content)
      end
    end
    
  end
  
end