module BxBlockAdmin
  module V1
    class ForgotPasswordsController < ApplicationController
      skip_before_action :validate_json_web_token, except: :reset_password
      skip_before_action :get_admin_user, except: :reset_password
      before_action :set_admin_user, except: :reset_password
      before_action :validate_password, :validate_token, only: :reset_password

      def create
        @admin_user.update(otp_code: rand(1_000..9_999), otp_valid_until: Time.current + 5.minutes)
        EmailOtpMailer.with(admin_user: @admin_user).otp_email.deliver_now
        render json: { 'messages': ['Otp sent successfully'] }, status: :ok
      end

      def otp_validate
        if @admin_user.valid_otp?(admin_user_params[:otp].to_i)
          token = BuilderJsonWebToken::AdminJsonWebToken.encode(
            @admin_user.id, { token_type: 'forgot_password' } , 5.minutes.from_now
          )
          render json: { token: token }, status: :ok
        else
          render json: {'errors' => ['Otp invalid/expired']}, status: :unprocessable_entity
        end
      end

      def reset_password
        if current_admin_user.update(reset_password_params)
          render json: { 'messages': ['Password updated successfully'] }, status: :ok
        else
          render json: {'errors' => ['Password update unsuccessful']}, status: :unprocessable_entity
        end
      end

      private

      def admin_user_params
        params.permit(:email, :otp)
      end

      def reset_password_params
        params.permit(:password, :password_confirmation)
      end

      def set_admin_user
        @admin_user = AdminUser.find_by_email(admin_user_params[:email])
        return render json: {'errors' => ['Admin user not found']}, status: :not_found if @admin_user.nil?
      end

      def validate_password
        password = reset_password_params[:password]
        if password.nil? || (password != reset_password_params[:password_confirmation])
          return render json: {'errors' => ['Passwords did not match']}, status: :unprocessable_entity
        end
      end

      def validate_token
        begin
          unless @token.token_type == "forgot_password"
            return render json: {'errors' => ['Invalid token type']}, status: :unprocessable_entity
          end
        rescue
          return render json: {'errors' => ['Invalid token type']}, status: :unprocessable_entity
        end
      end
    end
  end
end
