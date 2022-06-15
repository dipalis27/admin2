module BxBlockAdmin

  module V1
    
    class BrandSettingsController < ApplicationController

      def index
        @brand_setting = BxBlockStoreProfile::BrandSetting.last

        if @brand_setting.present?
          render json: BrandSettingSerializer.new(@brand_setting), status: :ok
        else
          render json: { message: "No brand setting found"}, status: 404
        end
      end

      def create
        @brand_setting = BxBlockStoreProfile::BrandSetting.create(brand_settings_params)

        if @brand_setting.save
          render json: @brand_setting, status: :ok
        else
          render json: { errors: @brand_setting.errors.full_messages }, status: 400
        end
      end

      def show
        begin
          @brand_setting = BxBlockStoreProfile::BrandSetting.find(params[:id])
          render(json: BrandSettingSerializer.new(@brand_setting).serializable_hash,status: :ok)
        rescue 
          render(json: { error: "No brand settings found" }, status:401)
      end
      end

      def update
        @brand_setting = BxBlockStoreProfile::BrandSetting.find(params[:id])

        if @brand_setting.update(brand_settings_params)
          render(json: @brand_setting,status: :ok, message: "Brand Settings updated successfully")
        else
          render(json:{ error: "No brand settings found"}, status:404)
        end
      end

      private

      def brand_settings_params
        params.permit(:heading, :sub_heading, :logo, :header_color, :common_button_color, :button_hover_color, :brand_text_color, :active_tab_color, :inactive_tab_color, :active_text_color, :inactive_text_color, :country, :currency_type, :phone_number, :fb_link, :instagram_link, :twitter_link, :youtube_link, :button_hover_text_color, :border_color, :sidebar_bg_color, :copyright_message, :wishlist_icon_color, :wishlist_btn_text_color, :order_detail_btn_color, :api_key, :auth_domain, :database_url, :project_id, :storage_bucket, :messaging_sender_id, :app_id, :measurement_id, :is_facebook_login, :is_google_login, :is_apple_login, :transparent_color, :grey_color, :black_color, :white_color, :primary_color, :background_grey_color, :extra_button_color, :header_text_color, :header_subtext_color, :background_color, :secondary_color, :secondary_button_color, :address, :gst_number, :highlight_primary_color, :highlight_secondary_color, :address_state_id, :template_selection, :color_palet, :whatsapp_number, :whatsapp_message)
      end
    end
    
  end

end
