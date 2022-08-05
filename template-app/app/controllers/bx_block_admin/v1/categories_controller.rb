module BxBlockAdmin
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: [:show, :update, :destroy, :validate_sub_category, :validate_category]

      def index
        categories =
          unless params[:search].present?
            BxBlockCategoriesSubCategories::Category.all
          else
            BxBlockCategoriesSubCategories::Category.left_joins(:sub_categories).where("LOWER(categories.name) LIKE LOWER(:search) OR LOWER(sub_categories.name) LIKE LOWER(:search)", search: "%#{params[:search]}%").distinct
          end
        categories = categories.order(updated_at: :desc).page(params[:page]).per(params[:per_page])
        render json: BxBlockAdmin::CategorySerializer.new(categories, pagination_data(categories, params[:per_page])).serializable_hash, status: :ok
      end

      def create
        categories, errors = ChangeCategoriesSubCategories.new(category_params['categories']).call
        render json: {
          categories: BxBlockAdmin::CategorySerializer.new(categories).serializable_hash,
          errors: errors
        }, status: :ok
      end

      def show
        if @category
          render json: BxBlockAdmin::CategorySerializer.new(@category).serializable_hash, status: :ok
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

      def validate_category
        render json: { 'errors' => ['Please pass a name'] }, status: :unprocessable_entity if validate_params[:name].blank?
        render json: { valid: !BxBlockCategoriesSubCategories::Category.where.not(id: @category&.id).exists?(name: validate_params[:name]) }, status: :ok
      end

      def validate_sub_category
        if @category
          render json: { 'errors' => ['Please pass a name'] }, status: :unprocessable_entity if validate_params[:name].blank?
          render json: { valid: !@category.sub_categories.exists?(name: validate_params[:name]) }, status: :ok
        else
          render json: {'errors' => ['Category not found']}, status: :not_found
        end
      end

      private 

      def category_params
        params.permit(categories: [
          :id, :name, :disabled, :_destroy, :image, sub_categories_attributes: [
            :id, :name, :image, :disabled, :_destroy
          ]
        ])
      end

      def validate_params
        params.permit(:id, :name)
      end

      def set_category
        @category = BxBlockCategoriesSubCategories::Category.find_by_id(params[:id])
      end
    end
  end
end
