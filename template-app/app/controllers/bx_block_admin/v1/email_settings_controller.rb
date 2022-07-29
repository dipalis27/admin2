module BxBlockAdmin
  module V1
    class EmailSettingsController < ApplicationController
      before_action :set_email_setting, only: %i( edit update show )

      def index
        email_setting_tabs = BxBlockSettings::EmailSettingTab.all
        result =  [] 
        email_setting_tabs.each do |tab|
          categories = tab.email_setting_categories.select(:id, :name)
          tab_hash = {
            tab_name: tab.name,
            count: categories.map{ |category| category.email_settings.count }.sum,
            categories: categories.map { |category| { category_name: category.name, email_settings: category.email_settings.select(:id, :title, :content, :active).order(:id) } }
          }
          result << tab_hash
        end
        render json: { data: result }, status: :ok
      end

      def create
        email_setting = BxBlockSettings::EmailSetting.new(email_setting_params)
        if email_setting.save
          render json: serialized_hash(email_setting), status: :ok
        else
          render json: { errors: email_setting.errors.full_messages }, status: :unprocessable_entity          
        end
      end

      def edit
        data = serialized_hash(@email_setting)[:data]
        data[:email_setting_categories] = BxBlockSettings::EmailSettingCategory.pluck(:name)
        data[:email_keywords] = BxBlockSettings::EmailSetting.keywords
        render json: data, status: :ok
      end

      def update
        @email_setting.update(email_setting_params)
        if @email_setting.save
          render json: serialized_hash(@email_setting), status: :ok
        else
          render json: { errors: @email_setting.errors.full_messages }, status: :unprocessable_entity          
        end
      end
      
      def show
        render json: serialized_hash(@email_setting), status: :ok
      end

      private

        def email_setting_params
          params.permit(:title, :content, :event_name, :email_setting_category_id, :active)
        end

        def set_email_setting
          begin
            @email_setting = BxBlockSettings::EmailSetting.find(params[:id])
          rescue => exception
            render json: { errors: ["EmailSetting not found."] }, status: :not_found
          end
        end

        # Calls base class method serialized_hash in application_controller
        def serialized_hash(obj, options: {}, serializer_class: BxBlockAdmin::EmailSettingSerializer)
          super(serializer_class, obj, options)
        end

    end
  end
end