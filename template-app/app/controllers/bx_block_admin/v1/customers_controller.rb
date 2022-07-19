module BxBlockAdmin
  module V1
    class CustomersController < ApplicationController
      before_action :set_customer, only: %i(show update destroy)

      def index
        customers = AccountBlock::Account.where.not(type: 'guest_account')
        if params[:search].present?
          customers = customers.where("LOWER(full_name) LIKE LOWER(:search) OR LOWER(full_phone_number) LIKE LOWER(:search) OR LOWER(email) LIKE LOWER(:search)", search: "%#{params[:search]}%")
        end

        customers = customers.page(params[:page]).per(params[:per_page])
        render json: CustomerSerializer.new(customers).serializable_hash, status: :ok
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
    end
  end
end
