module BxBlockAdmin
  module V1
    class OrdersController < ApplicationController
      before_action :set_order, only: [:show, :update, :update_delivery_address]
      def index
        orders = BxBlockOrderManagement::Order.not_in_cart.order(order_date: :desc)
        @placed_orders_count = orders.where(status: 'placed').size
        @deliverd_orders_count = orders.where(status: 'delivered').size
        @cancelled_orders_count = orders.where(status: 'cancelled').size
        @refunded_orders_count = orders.where(status: 'refunded').size
        @total_count = orders.size

        per_page = params[:per_page].present? ? params[:per_page].to_i : 10
        current_page = params[:page].present? ? params[:page].to_i : 1
          if params[:term].present?
            orders = orders.not_in_cart.search_by_order_number_or_customer_name(params[:term]).page(current_page).per(per_page)
          end
          if params[:filter].present?
            if params[:filter][:from_date].present? && params[:filter][:to_date].present?
              orders = orders.filter_by_date(params[:filter][:from_date], params[:filter][:to_date]).page(current_page).per(per_page)
            end
            if params[:filter][:statuses].present?
              orders = orders.filter_by_statuses(params[:filter][:statuses]).page(current_page).per(per_page)
            end
            if params[:filter][:from_amount].present? && params[:filter][:to_amount]
              orders = orders.filter_by_amount(params[:filter][:from_amount], params[:filter][:to_amount]).page(current_page).per(per_page)
            end

          elsif params[:status].present?
            orders = orders.not_in_cart.where(status: params[:status]).order(order_date: :desc).page(current_page).per(per_page)
          else
          orders =  orders.includes(:account, :order_items).not_in_cart.order(order_date: :desc).page(current_page).per(per_page)
        end       
        render json: BxBlockAdmin::OrderSerializer.new(orders, pagination_payload(orders, per_page)).serializable_hash, status: :ok
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

      def download_csv_report
        reponse = BxBlockOrderManagement::Order.generate_csv_report
        if reponse[:success]
          render json: {csv_data: reponse[:data]}, status: :ok
        else
          render json: {errors: [reponse[:message]]}, status: :unprocessable_entity
        end
      end

      def send_to_shiprocket
        @order = BxBlockOrderManagement::Order.includes(:order_items).find_by_id(params[:order_id])
        if @order.present?
          ship_rocket = BxBlockOrderManagement::ShipRocket.new
          if ship_rocket.authorize
            response = ship_rocket.post_order(@order.id)
            json_response = JSON.parse(response.body)
            if json_response['errors'].present?
              return render json: { errors: json_response['errors'].values.flatten }, status: :unprocessable_entity
            else
              @order.update_shipment_details(json_response)
              @order.update_tracking(json_response)  if @order.order_items.present?
              return render json: { 'messages': "Order has been sent to Shiprocket." }, status: :ok
            end
          else
            render json: { errors: ["Unable to authorize Shiprocket credentials and please check Shiprocket email and password."]}, status: :unprocessable_entity
          end
        else
          render json: { errors: ["Order not found"]}, status: :unprocessable_entity
        end
      end

      private
        
        def set_order
          @order = BxBlockOrderManagement::Order.includes(:order_items).find_by_id(params[:id])
        end

        def order_params
          params.permit(:status, :length, :breadth, :height, :weight, :package_id)
        end

        def delivery_address_params
          params.permit(:name, :flat_no, :address, :zip_code, :phone_number, :city, :state, :address_for, :landmark, :country, :address_state_id)
        end

        def serialization_options
          request_hash = { params: {order_items: true, delivery_addresses: true } }
          request_hash
        end

        def pagination_payload(orders, per_page)
          options = {}
          options[:meta] = {
            pagination: {
              current_page: orders.current_page,
              next_page: orders.next_page,
              prev_page: orders.prev_page,
              total_pages: orders.total_pages,
              total_count: @total_count,
              placed_orders_count: @placed_orders_count,
              deliverd_orders_count: @deliverd_orders_count,
              refunded_orders_count: @refunded_orders_count,
              cancelled_orders_count: @cancelled_orders_count,
              current_count: orders.count,
              per_page: per_page
            }
          }
          options
        end
    end
  end
end
