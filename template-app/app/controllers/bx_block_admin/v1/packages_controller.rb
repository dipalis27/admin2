module BxBlockAdmin
  module V1
    class PackagesController < ApplicationController
      before_action :set_package, only: %i(update show destroy)

      def index
        packages = BxBlockOrderManagement::Package.order(id: :desc).page(params[:page]).per(params[:per_page])
        render json: serialized_hash(packages, options: pagination_data(packages, params[:per_page])), status: :ok
      end

      def create
        package = BxBlockOrderManagement::Package.new(package_params)
        if package.save
          render json: serialized_hash(package), status: :ok
        else
          render json: { errors: package.errors.full_messages }, status: :unprocessable_entity          
        end
      end

      def update
        if @package.update(package_params)
          render json: serialized_hash(@package), status: :ok
        else
          render json: { errors: @package.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: serialized_hash(@package), status: :ok
      end

      def destroy
        if @package.destroy
          render json: { message: "Package deleted successfully." }, status: :ok
        else
          render json: { errors: @package.errors.full_messages }, status: :unprocessable_entity   
        end
      end

      private

        def package_params
          params.permit(:name, :length, :width, :height)
        end

        def set_package
          begin
            @package = BxBlockOrderManagement::Package.find(params[:id])
          rescue => exception
            render json: { errors: ["Package not found."] }, status: :not_found
          end
        end

        # Calls base class method serialized_hash in application_controller
        def serialized_hash(obj, options: {}, serializer_class: BxBlockAdmin::PackageSerializer)
          super(serializer_class, obj, options)
        end
    
    end
  end
end
