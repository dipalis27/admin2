module BxBlockAdmin

  module V1

    class InteractiveFaqsController < ApplicationController
      before_action :set_faq, only:[:show, :update, :destroy]

      def index
        @faqs = BxBlockInteractiveFaqs::InteractiveFaqs.all

        if @faqs.present?
          render json: InteractiveFaqsSerializer.new(@faqs), status: :ok
        else
          render json: { message: "No FAQ found"}, status: 404
        end
      end

      def create
        @faq = BxBlockInteractiveFaqs::InteractiveFaqs.create(faq_params)

        if @faq.save
          render json: InteractiveFaqsSerializer.new(@faq), status: :ok
        else
          render json: { errors: @faq.errors.full_messages }, status: 400
        end
      end

      def bulk_create
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
        render json: InteractiveFaqsSerializer.new(@faq), status: :ok
      end

      def update
        @faq.assign_attributes(faq_params)
        if @faq.update(faq_params)
          render json: InteractiveFaqsSerializer.new(@faq), status: :ok
        else
          render json:{ "errors": @faq.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def bulk_update
        res = {}
        ary = []
        params["_json"].each do |attrs|
          ActiveRecord::Base.transaction do
            obj = BxBlockInteractiveFaqs::InteractiveFaqs.find(attrs[:id])
            obj.title = attrs[:title]
            obj.content = attrs[:content]
            # obj = BxBlockInteractiveFaqs::InteractiveFaqs.new(title: attrs[:title], content: attrs[:content])
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

      def destroy
        if @faq.destroy
          render json: { message: "FAQ deleted successfully.", success: true}, status: :ok
        else
          render json: {"errors": @faq.errors.full_messages}, status: :unprocessable_entity
        end
      end

      private

      def faq_params
        params.permit(:id, :title, :content)
      end

      def set_faq
        begin
          @faq = BxBlockInteractiveFaqs::InteractiveFaqs.find(faq_params[:id])
        rescue 
          render json: ["errors": "No faq found"], status: :not_found
        end
      end
    end
    
  end
  
end