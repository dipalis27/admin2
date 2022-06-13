module BxBlockAdmin
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::AdminJsonWebTokenValidation

    before_action :validate_json_web_token
    before_action :get_admin_user

    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    private

    def not_found
      render :json => {'errors' => ['Admin user not found']}, :status => :not_found
    end

    def get_admin_user
      @current_admin_user = AdminUser.find(@token.admin_user_id)
    end
  end
end
