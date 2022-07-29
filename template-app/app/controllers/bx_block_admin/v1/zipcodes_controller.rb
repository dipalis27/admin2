module BxBlockAdmin
  module V1
    class ZipcodesController < ApplicationController
      before_action :set_zipcode, only: [:show, :update, :destroy]
      
      def index
        per_page = params[:per_page].present? ? params[:per_page].to_i : 10
        current_page = params[:page].present? ? params[:page].to_i : 1
        zipcodes = BxBlockZipcode::Zipcode.order(created_at: :desc).page(current_page).per(per_page)
        options = {}
        options[:meta] = {
          pagination: {
            current_page: zipcodes.current_page,
            next_page: zipcodes.next_page,
            prev_page: zipcodes.prev_page,
            total_pages: zipcodes.total_pages,
            total_count: zipcodes.total_count
          }
        }
        render json: BxBlockAdmin::ZipcodeSerializer.new(zipcodes, options).serializable_hash, status: :ok      
      end

      def create
        zipcode = BxBlockZipcode::Zipcode.new(zipcode_params)
        if zipcode.save
          render json: BxBlockAdmin::ZipcodeSerializer.new(zipcode).serializable_hash, status: :ok
        else
          render json: {errors: [zipcode.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end

      def update
        return render json: {errors: ['Zipcode not found.']}, status: :unprocessable_entity if @zipcode.blank?
        if @zipcode.update(zipcode_params)
          render json: BxBlockAdmin::ZipcodeSerializer.new(@zipcode).serializable_hash, status: :ok
        else
          render json: {errors: [@zipcode.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end

      def show
        if @zipcode
          render json: BxBlockAdmin::ZipcodeSerializer.new(@zipcode).serializable_hash, status: :ok
        else
          render json: {errors: ['Zipcode not found.']}, status: :unprocessable_entity
        end
      end

      def destroy
        if @zipcode
          @zipcode.destroy
          render json: {message: 'Zipcode delete successfully.'}, status: :ok
        else
          render json: {errors: ['Zipcode not found.']}, status: :unprocessable_entity
        end
      end

      private
        def set_zipcode
          @zipcode = BxBlockZipcode::Zipcode.find_by_id(params[:id])
        end

        def zipcode_params
          params.permit(:code, :activated, :charge, :price_less_than)
        end
    end
  end
end
