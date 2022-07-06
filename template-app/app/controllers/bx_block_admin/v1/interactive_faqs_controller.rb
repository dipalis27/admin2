module BxBlockAdmin

  module V1

    class InteractiveFaqsController < ApplicationController
      
      def index
        @faq = BxBlockInteractiveFaqs::InteractiveFaqs.all

        if @faq.present?
          render json: @faq, status: :ok
        else
          render json: { message: "No FAQ found"}, status: 404
        end
      end

      def create
        res = {}
        ary = []
        params["_json"].each do |attrs|
          ActiveRecord::Base.transaction do
            obj = BxBlockInteractiveFaqs::InteractiveFaqs.new(title: attrs[:title], content: attrs[:content])
            obj.save!
            ary.push(obj)
          end
        rescue ActiveRecord::RecordInvalid => e
          res = { errors: e.message }
        end
        if res[:errors].present?
          render json: res.to_json, status: :ok
        else
          render json:InteractiveFaqsSerializer.new(ary) , status: :ok
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