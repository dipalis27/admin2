module BxBlockAdmin

  module V1

    class HelpCentersController < ApplicationController
      before_action :set_static, only:[:show, :update, :destroy]

      def index
        @static_page = BxBlockHelpCenter::HelpCenter.all

        if @static_page.present?
          render json: @static_page, status: :ok
        else
          render json: { message: "No static pages found"}, status: 404
        end
      end

      def create
        @static_page = BxBlockHelpCenter::HelpCenter.create(help_center_params)

        if @static_page.save
          render json: @static_page, status: :ok
        else
          render json: { errors: @static_page.errors.full_messages }, status: 400
        end
      end

      def show
        render json: @static_page, status: :ok
      end

      def update
        if @static_page.update(help_center_params)
          render json: { data: @static_page,  message: "Static Page updated successfully" }, status: :ok
        else
          render json: {"errors": @static_page.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def destroy
        if @static_page.destroy
          render json: { message: "Static page deleted successfully", success: true}, status: :ok
        else
          render json: {"errors": @static_page.errors.full_messages}, status: :unprocessable_entity
        end
      end

      private

      def help_center_params
        params.permit(:id, :help_center_type, :title, :description, :status)
      end

      def set_static
        begin
          @static_page = BxBlockHelpCenter::HelpCenter.find(help_center_params[:id])
        rescue 
          render json: {"error": "No static pages found"}, status: :not_found
        end
      end
    end
  end  
end


