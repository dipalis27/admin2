module BxBlockAdmin
  module V1
    class QrCodesController < ApplicationController
      before_action :set_qr_code, only: %i(show update destroy)

      def index
        render json: QrCodeSerializer.new(BxBlockApiConfiguration::QrCode.all).serializable_hash, status: :ok
      end

      def show
        render json: QrCodeSerializer.new(@qr_code).serializable_hash, status: :ok
      end

      def create
        qr_code = BxBlockApiConfiguration::QrCode.new(qr_code_params)
        if qr_code.save
          render json: QrCodeSerializer.new(qr_code).serializable_hash, status: :ok
        else
          render json: { 'errors': qr_code.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @qr_code.update(qr_code_params)
          render json: QrCodeSerializer.new(@qr_code).serializable_hash, status: :ok
        else
          render json: { 'errors': @qr_code.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if @qr_code.destroy
          render json: { 'messages': 'Qr Code removed successfully' }, status: :ok
        else
          render json: { 'errors': @qr_code.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def qr_code_params
        params.permit(:id, :code_type, :url)
      end

      def set_qr_code
        begin
          @qr_code = BxBlockApiConfiguration::QrCode.find(qr_code_params[:id])
        rescue
          render json: { 'errors': ['Qr Code not found'] }, status: :not_found
        end
      end
    end
  end
end
