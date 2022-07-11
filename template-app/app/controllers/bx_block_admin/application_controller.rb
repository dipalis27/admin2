module BxBlockAdmin
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::AdminJsonWebTokenValidation
    include BxBlockAdmin::ModelUtilities

    before_action :validate_json_web_token
    before_action :get_admin_user
    before_action :validate_admin

    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    EXCEPTION_ROUTES = [
      'bx_block_admin/v1/admin_users#show', 'bx_block_admin/v1/admin_users#update',
      'bx_block_admin/v1/onboarding#index'
    ]

    private

    def not_found
      render :json => {'errors' => ['Record not found']}, :status => :not_found
    end

    def get_admin_user
      @current_admin_user = AdminUser.find(@token.admin_user_id)
    end

    def validate_admin
      if @current_admin_user.super_admin?
        return
      else
        return if EXCEPTION_ROUTES.include?(params['controller'] + "##{params['action']}")
        if (permission = AdminUser::PERMISSION_ROUTES[params['controller']]).present?
          return if @current_admin_user.permissions.include?(permission)
        end
        render :json => {'errors' => ['Permission denied!']}, status: :forbidden
      end
    end
  end
end
