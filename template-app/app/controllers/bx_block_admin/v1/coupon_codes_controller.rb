module BxBlockAdmin
  module V1
    class CouponCodesController < ApplicationController
      before_action :set_coupon, only: %i(show update destroy)

      def index
        per_page = params[:per_page].present? ? params[:per_page].to_i : 10
        current_page = params[:page].present? ? params[:page].to_i : 1
        coupons = BxBlockCouponCodeGenerator::CouponCode.order(updated_at: :desc).page(current_page).per(per_page)
        render json: CouponCodeSerializer.new(coupons, pagination_data(coupons, per_page)).serializable_hash, status: :ok
      end

      def create
        coupon = BxBlockCouponCodeGenerator::CouponCode.new(coupon_params)
        if coupon.save
          render json: CouponCodeSerializer.new(coupon).serializable_hash, status: :ok
        else
          render json: { 'errors': coupon.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: CouponCodeSerializer.new(@coupon).serializable_hash, status: :ok
      end

      def update
        if @coupon.update(coupon_params)
          render json: CouponCodeSerializer.new(@coupon).serializable_hash, status: :ok
        else
          render json: { 'errors': @coupon.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if @coupon.destroy
          render json: { 'messages': ['Promo code has been removed'] }, status: :ok
        else
          render json: { 'errors': @coupon.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def coupon_params
        params.permit(
          :id, :title, :description, :code, :discount_type, :discount, :valid_from,
          :valid_to, :min_cart_value, :max_cart_value, :limit
        )
      end

      def set_coupon
        begin
          @coupon = BxBlockCouponCodeGenerator::CouponCode.find(coupon_params[:id])
        rescue
          render json: { 'errors': ['Promo code not found'] }, status: :not_found
        end
      end
    end
  end
end
