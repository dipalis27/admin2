module BxBlockAdmin
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: [:show, :update, :destroy]

      def index
        per_page = params[:per_page].present? ? params[:per_page].to_i : 10
        current_page = params[:page].present? ? params[:page].to_i : 1
        categories = BxBlockCategoriesSubCategories::Category.order(name: :asc).page(current_page).per(per_page)
        options = {}
        options[:meta] = {
          pagination: {
            current_page: categories.current_page,
            next_page: categories.next_page,
            prev_page: categories.prev_page,
            total_pages: categories.total_pages,
            total_count: categories.total_count
          }
        }
        render json: BxBlockAdmin::CategorySerializer.new(categories, options).serializable_hash, status: :ok
      end

      def create
        category = BxBlockCategoriesSubCategories::Category.new(category_params)
        if category.save
          render json: BxBlockAdmin::CategorySerializer.new(category).serializable_hash, status: :ok
        else
          render json: {'errors' => [category.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end

      def update
        if @category.update(category_params)
          render json: BxBlockAdmin::CategorySerializer.new(@category).serializable_hash, status: :ok
        else
          render json: {'errors' => [@category.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end

      def show
        if @category
          render json: BxBlockAdmin::CategorySerializer.new(@category, serialization_options).serializable_hash, status: :ok
        else
          render json: {'errors' => ['Category not found']}, status: :not_found
        end
      end

      def destroy
        if @category
          @category.destroy
          render json: { message: "Category deleted successfully.", success: true}, status: :ok
        else
          render json: {'errors' => ['Category not found']}, status: :not_found
        end
      end

      private 

        def category_params
          params.permit(:name, :image)
        end

        def set_category
          @category = BxBlockCategoriesSubCategories::Category.find_by_id(params[:id])
        end

        def serialization_options
          request_hash = { params: {sub_categories: true } }
          request_hash
        end

    end
  end
end
