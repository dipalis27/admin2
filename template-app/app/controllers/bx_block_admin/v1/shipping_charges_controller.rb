module BxBlockAdmin
  module V1
    class ShippingChargesController < ApplicationController
      before_action :set_shipping_charge, only: [:show, :update, :destroy]

      def index
        per_page = params[:per_page].present? ? params[:per_page].to_i : 10
        current_page = params[:page].present? ? params[:page].to_i : 1
        shipping_charges = BxBlockShippingCharge::ShippingCharge.order(updated_at: :desc).page(current_page).per(per_page)
        render json: BxBlockAdmin::ShippingChargeSerializer.new(shipping_charges, pagination_data(shipping_charges, per_page)).serializable_hash, status: :ok
      end

      def create
        shipping_charge = BxBlockShippingCharge::ShippingCharge.new(shipping_charge_params)
        if shipping_charge.save
          render json: BxBlockAdmin::ShippingChargeSerializer.new(shipping_charge).serializable_hash, status: :ok
        else
          render json: {errors: [shipping_charge.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end

      def update
        if @shipping_charge
          if @shipping_charge.update(shipping_charge_params)
            render json: BxBlockAdmin::ShippingChargeSerializer.new(@shipping_charge).serializable_hash, status: :ok
          else
            render json: {errors: [@shipping_charge.errors.full_messages.to_sentence]}, status: :unprocessable_entity
          end
        else
          render json: {errors: ['Shipping charge not found.']}, status: :unprocessable_entity
        end
      end

      def show
        if @shipping_charge
          render json: BxBlockAdmin::ShippingChargeSerializer.new(@shipping_charge).serializable_hash, status: :ok
        else
          render json: {errors: ['Shipping charge not found.']}, status: :unprocessable_entity
        end
      end

      def destroy
        if @shipping_charge
          @shipping_charge.destroy
          render json: {message: 'Shipping charge delete successfully.'}, status: :ok
        else
          render json: {errors: ['Shipping charge not found.']}, status: :unprocessable_entity
        end
      end

      private
        def set_shipping_charge
          @shipping_charge = BxBlockShippingCharge::ShippingCharge.find_by_id(params[:id])
        end

        def shipping_charge_params
          params.permit(:below, :charge, :free_shipping)
        end
    end
  end
end
