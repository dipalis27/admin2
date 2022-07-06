module BxBlockAdmin
  module V1
    class OrdersController < ApplicationController
      before_action :set_order, only: [:show, :update, :update_delivery_address]
      def index
        per_page = params[:per_page].present? ? params[:per_page].to_i : 10
        current_page = params[:page].present? ? params[:page].to_i : 1
        orders =  BxBlockOrderManagement::Order.includes(:account).not_in_cart.order(order_date: :desc).page(current_page).per(per_page)
        
        placed_orders = orders.where(status: 'placed')
        deliverd_orders = orders.where(status: 'delivered')
        cancelled_orders = orders.where(status: 'cancelled')
        refunded_orders = orders.where(status: 'refund')

        options = {}
        options[:meta] = {
          pagination: {
            current_page: orders.current_page,
            next_page: orders.next_page,
            prev_page: orders.prev_page,
            total_pages: orders.total_pages,
            total_count: orders.total_count,
            placed_orders_count: placed_orders.size,
            deliverd_orders_count: deliverd_orders.size,
            refunded_orders_count: refunded_orders.size,            
          }
        }
        render json: BxBlockAdmin::OrderSerializer.new(orders, options).serializable_hash, status: :ok
      end

      def show
        if @order
          render json: BxBlockAdmin::OrderSerializer.new(@order, serialization_options).serializable_hash, status: :ok
        else
          render json: {errors: [{message: "Order Not Found"},
          ]}, status: :unprocessable_entity
        end
      end

      def update
        if @order.update(order_params)
          render json: BxBlockAdmin::OrderSerializer.new(@order, serialization_options).serializable_hash, status: :ok
        else
          render json: {errors: [{message: @order.errors.full_messages.to_sentence },
          ]}, status: :unprocessable_entity
        end
      end

      def update_delivery_address
        @order = BxBlockOrderManagement::Order.find_by_id(params[:order_id])
        @delivery_address = @order.delivery_addresses.find_by_id(params[:id])
        if @delivery_address
          if @delivery_address.update(delivery_address_params)
            render json: BxBlockAdmin::DeliveryAddressSerializer.new(@delivery_address).serializable_hash, status: :ok
          else
            render json: { errors: [@delivery_address.errors.full_messages.to_sentence]}, status: :unprocessable_entity
          end
        else
          render json: { errors: ["Delivery Address Not Found"]}, status: :unprocessable_entity
        end
      end

      private
        
        def set_order
          @order = BxBlockOrderManagement::Order.includes(:order_items).find_by_id(params[:id])
        end

        def order_params
          params.permit(:status, :length, :breadth, :height, :weight)
        end

        def delivery_address_params
          params.permit(:name, :flat_no, :address, :zip_code, :phone_number, :city, :state, :address_for, :landmark, :country, :address_state_id)
        end

        def serialization_options
          request_hash = { params: {order_items: true, delivery_addresses: true } }
          request_hash
        end
    end
  end
end
