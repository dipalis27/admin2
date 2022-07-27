module BxBlockAdmin
  module V1
    class DefaultEmailSettingsController < ApplicationController
      before_action :set_default_email_setting, only: %i(edit update show destroy)
      before_action :default_email_setting_exists?, only: %i(new create)

      def new
        render json: { required_fields: required_fields, send_email_copy_methods: email_copy_methods }, status: :ok
      end

      def create
        default_email_setting = BxBlockSettings::DefaultEmailSetting.new(default_email_setting_params)
        attach_logo(default_email_setting)
        if default_email_setting.save
          render json: serialized_hash(default_email_setting), status: :ok
        else
          render json: { errors: default_email_setting.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def edit
        render json: { required_fields: required_fields, send_email_copy_methods: email_copy_methods }, status: :ok
      end

      def update
        attach_logo(@default_email_setting)
        @default_email_setting.assign_attributes(default_email_setting_params)
        if @default_email_setting.save
          render json: serialized_hash(@default_email_setting), status: :ok
        else
          render json: { errors: @default_email_setting.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: serialized_hash(@default_email_setting), status: :ok
      end

      def destroy
        if @default_email_setting.destroy
          render json: { message: "Default email setting deleted successfully.", success: true }, status: :ok
        else
          render json: { errors: @default_email_setting.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

        def default_email_setting_params
          params.permit(:brand_name, :from_email, :recipient_email, :contact_us_email_copy_to, :send_email_copy_method)
        end

        def set_default_email_setting
          begin
            @default_email_setting = BxBlockSettings::DefaultEmailSetting.find(params[:id])
          rescue => exception
            render json: { errors: ["EmailSetting not found."] }, status: :not_found
          end
        end

        def required_fields
          BxBlockSettings::DefaultEmailSetting.validators.select{ |v| v.instance_of?(ActiveRecord::Validations::PresenceValidator) }.map{ |v| v.attributes }.flatten
        end

        def email_copy_methods
          BxBlockSettings::DefaultEmailSetting::EMAIL_COPY_METHODS 
        end

         # Calls base class method serialized_hash in application_controller
         def serialized_hash(obj, options: {}, serializer_class: BxBlockAdmin::DefaultEmailSettingSerializer)
          super(serializer_class, obj, options)
        end

        def default_email_setting_exists?
          if BxBlockSettings::DefaultEmailSetting.last.present?
            render json: {errors: ["Default email setting already exists. Try to edit it."] }, status: :unprocessable_entity
          end
        end

        def attach_logo(obj)
          if params[:logo].present?
            logo_path, logo_extension = store_base64_image(params[:logo])
            obj.logo.attach(io: File.open(logo_path), filename: "#{obj.brand_name}-logo.#{logo_extension}")
            File.delete(logo_path) if File.exist?(logo_path)
          end
        end

    end
  end
end