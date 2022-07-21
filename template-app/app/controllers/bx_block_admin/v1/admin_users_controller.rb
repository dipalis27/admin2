module BxBlockAdmin
  module V1
    class AdminUsersController < ApplicationController
      before_action :validate_password, only: [:update]
      before_action :validate_super_admin, only: %i(sub_admin_users create_sub_admin update_sub_admin show_sub_admin destroy_sub_admin)
      before_action :set_sub_admin, only: %i(update_sub_admin show_sub_admin destroy_sub_admin)

      def show
        render json: AdminUserSerializer.new(@current_admin_user).serializable_hash, status: :ok
      end

      def update
        if @current_admin_user.update(admin_user_params)
          render json: AdminUserSerializer.new(@current_admin_user).serializable_hash, status: :ok
        else
          render json: {'errors' => @current_admin_user.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def sub_admin_users
        render json: AdminUserSerializer.new(AdminUser.sub_admin).serializable_hash, status: :ok
      end

      def sub_admin_count
        render json: { sub_admin_count: AdminUser.sub_admin.count }, status: :ok
      end

      def show_sub_admin
        render json: AdminUserSerializer.new(@admin_user).serializable_hash, status: :ok
      end

      def permissions
        render json: { permissions: AdminUser::PERMISSION_KEYWORDS }
      end

      def create_sub_admin
        @admin_user = AdminUser.new(sub_admin_params)
        @admin_user.role = 'sub_admin'
        if @admin_user.save
          render json: AdminUserSerializer.new(@admin_user).serializable_hash, status: :ok
        else
          render json: {'errors' => @admin_user.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def update_sub_admin
        @admin_user.assign_attributes(sub_admin_params.except(:permissions))
        permissions = @admin_user.permissions
        permissions << sub_admin_params[:permissions]
        @admin_user.permissions = permissions.flatten.compact.uniq
        if @admin_user.save
          @admin_user.admin_profile.present? ? @admin_user.admin_profile.update(name: @admin_user.name, phone: @admin_user.phone_number, email: @admin_user.email) : BxBlockRoleAndPermission::AdminProfile.create(name: @admin_user.name, phone: @admin_user.phone_number, email: @admin_user.email, admin_user_id: @admin_user.id)
          render json: AdminUserSerializer.new(@admin_user).serializable_hash, status: :ok
        else
          render json: {'errors' => @admin_user.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def destroy_sub_admin
        if @admin_user.destroy
          render json: {'messages': ['Sub admin has been removed']}, status: :ok
        else
          render json: {'errors' => @admin_user.errors.full_messages}, status: :unprocessable_entity
        end
      end

      private

      def admin_user_params
        params.permit(:email, :phone_number, :name, :password, :password_confirmation)
      end

      def sub_admin_params
        params.permit(:id, :email, :phone_number, :name, :password, :password_confirmation, permissions: [])
      end

      def validate_password
        unless (password = admin_user_params[:password]).nil?
          return render json: {'errors' => ['Passwords did not match']}, status: :unprocessable_entity if password != admin_user_params[:password_confirmation]
        end
      end

      def validate_super_admin
        unless @current_admin_user.super_admin?
          return render json: {'errors' => ['Only super admin can access the API']}, status: :unprocessable_entity if password != admin_user_params[:password_confirmation]
        end
      end

      def set_sub_admin
        @admin_user = AdminUser.sub_admin.find_by_id(sub_admin_params[:id])
        return render json: {'errors' => ['Sub admin not found']}, status: :not_found if @admin_user.nil?
      end
    end
  end
end
