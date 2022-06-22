module BxBlockAdmin

  module V1

    class HelpCentersController < ApplicationController

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
        begin
          @static_page = BxBlockHelpCenter::HelpCenter.find(params[:id])
          render json: @static_page, status: :ok
        rescue 
          render(json: { error: "No static pages found" }, status:404)
        end
      end

      def update
        @static_page = BxBlockHelpCenter::HelpCenter.find(params[:id])

        if @static_page.update(help_center_params)
          render json: { data: @static_page,  message: "Static Page updated successfully" }, status: :ok
        else
          render(json:{ error: "No static page found"}, status:404)
        end
      end

      def destroy
        @static_page = BxBlockHelpCenter::HelpCenter.find(params[:id])

        if @static_page.destroy
          render json: { message: "Static page deleted successfully", success: true}, status: :ok
        else
          render json: {message: "No static page found", success:false}, status: :unprocessable_entity
        end
      end

      private

      def help_center_params
        params.permit(:help_center_type, :title, :description, :status)
      end
    end
  end  
end


