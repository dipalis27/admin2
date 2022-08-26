module BxBlockAdmin
  module V1
    class CustomersController < ApplicationController
      before_action :set_customer, only: %i(show update destroy)

      def index
        per_page = filter_params[:per_page].present? ? filter_params[:per_page].to_i : 10
        current_page = filter_params[:page].present? ? filter_params[:page].to_i : 1
        customers = fetch_customers

        customers = customers.order(updated_at: :desc).page(current_page).per(per_page)
        render json: CustomerSerializer.new(customers, pagination_data(customers, per_page)).serializable_hash, status: :ok
      end

      def create
        customer = AccountBlock::Account.new(customer_params)
        customer.type = 'EmailAccount'
        if image_params.present?
          image_path, image_extension = store_base64_image(image_params[:image])
          customer.image.attach(io: File.open(image_path), filename: "profile pic.#{image_extension}")
          File.delete(image_path) if File.exist?(image_path)
        end

        if customer.save
          render json: CustomerSerializer.new(customer).serializable_hash, status: :ok
        else
          render json: { 'errors': customer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: CustomerSerializer.new(@customer).serializable_hash, status: :ok
      end

      def update
        if image_params.present?
          image_path, image_extension = store_base64_image(image_params[:image])
          @customer.image.attach(io: File.open(image_path), filename: "profile pic.#{image_extension}")
          File.delete(image_path) if File.exist?(image_path)
        end
        @customer.assign_attributes(customer_params)
        if @customer.save
          render json: CustomerSerializer.new(@customer).serializable_hash, status: :ok
        else
          render json: { 'errors': @customer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if @customer.destroy
          render json: { 'messages': ['Customer has been removed'] }, status: :ok
        else
          render json: { 'errors': @customer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def customer_params
        params.permit(
          :id, :full_name, :email, :password, :activated, :full_phone_number,
          delivery_addresses_attributes: [
            :id, :name, :flat_no, :address, :address_line_2, :city, :state, :country, :zip_code,
            :phone_number, :_destroy
          ]
        )
      end

      def filter_params
        params.permit(:search, :activated, :page, :per_page)
      end

      def image_params
        params.permit(:image)
      end

      def set_customer
        begin
          @customer = AccountBlock::Account.find(customer_params[:id])
        rescue
          render json: { 'errors': ['Customer not found'] }, status: :not_found
        end
      end

      def fetch_customers
        customers = AccountBlock::Account.where.not(type: 'guest_account')
        if filter_params[:activated].present?
          case filter_params[:activated]
          when 'true'
            customers = customers.active
          when 'false'
            customers = customers.inactive
          end
        end

        if filter_params[:search].present?
          customers = customers.where("LOWER(full_name) LIKE LOWER(:search) OR LOWER(full_phone_number) LIKE LOWER(:search) OR LOWER(email) LIKE LOWER(:search)", search: "%#{params[:search]}%")
        end
        customers
      end
    end
  end
end
