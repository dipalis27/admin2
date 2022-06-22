module BxBlockAdmin
  module V1
    class OrdersController < ApplicationController

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
        @order = BxBlockOrderManagement::Order.includes(:order_items).find_by_id(params[:id])
        if @order
          render json: BxBlockAdmin::OrderSerializer.new(@order, serialization_options).serializable_hash, status: :ok
        else
          render json: {errors: [{message: "Order Not Found"},
          ]}, status: :unprocessable_entity
        end
      end

      def update
        @order = BxBlockOrderManagement::Order.includes(:order_items).find_by_id(params[:id])
        if @order.update(order_params)
          render json: BxBlockAdmin::OrderSerializer.new(@order, serialization_options).serializable_hash, status: :ok
        else
          render json: {errors: [{message: @order.errors.full_messages.to_sentence },
          ]}, status: :unprocessable_entity
        end
      end

      private
        
        def order_params
          params.permit(:status, :length, :breadth, :height, :weight)
        end

        def serialization_options
          request_hash = { params: {order_items: true } }
          request_hash
        end
    end
  end
end
