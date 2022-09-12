module BxBlockAdmin
  module V1
    class LoginsController < ApplicationController
      skip_before_action :validate_json_web_token
      skip_before_action :get_admin_user
      skip_before_action :validate_admin
      before_action :set_admin_user

      def create
        if @admin_user.valid_password?(admin_user_params[:password])
          render json: {
            token: BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id),
            build_card_id: ENV['BUILD_CARD_ID'],
            admin_user: AdminUserSerializer.new(@admin_user).serializable_hash
          }, status: :ok
        else
          render json: {'errors' => ['Invalid password']}, status: :unprocessable_entity
        end
      end

      private

      def admin_user_params
        params.permit(:email, :password)
      end

      def set_admin_user
        @admin_user = AdminUser.find_by_email(admin_user_params[:email])
        return render json: {'errors' => ['Admin user not found']}, status: :not_found if @admin_user.nil?
      end
    end
  end
end
