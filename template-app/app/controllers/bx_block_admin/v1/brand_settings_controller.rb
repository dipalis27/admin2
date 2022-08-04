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
        @brand_setting = BxBlockStoreProfile::BrandSetting.last
        if @brand_setting.present?
          return render json: {errors: ["Brand setting already exist."]}, status: :unprocessable_entity
        end
        @brand_setting = BxBlockStoreProfile::BrandSetting.new(brand_settings_params)
        @brand_setting.logo.attach(data: params[:logo]) if params[:logo].present?
        @brand_setting.favicon_logo.attach(data: params[:favicon_logo]) if params[:favicon_logo].present?
        if @brand_setting.valid?
          response = BxBlockBanner::Banner.validate_and_save(params[:banners]) if params[:banners].present?

          if response[:success]
            @brand_setting.save
            return render json: BrandSettingSerializer.new(@brand_setting), status: :ok
          else
            render json: { errors: [response[:message]] }, status: :unprocessable_entity
          end
        else
          render json: { errors: @brand_setting.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        @brand_setting = BxBlockStoreProfile::BrandSetting.find_by_id(params[:id])
        if @brand_setting
          if @brand_setting.update(brand_settings_params)
            @brand_setting.logo.attach(data: params[:logo]) if params[:logo].present?
            @brand_setting.favicon_logo.attach(data: params[:favicon_logo]) if params[:favicon_logo].present?
            response = BxBlockBanner::Banner.validate_and_save(params[:banners]) if params[:banners].present?
            return render json: BrandSettingSerializer.new(@brand_setting), status: :ok
          else
            return render json: { errors: [@brand_setting.errors.full_messages.to_sentence] }, status: :unprocessable_entity
          end
        else
          render json: { errors: ["Brand setting not found."] }, status: :not_found
        end
      end

      def add_banner
        @banner = BxBlockBanner::Banner.create(banner_params)
        if @banner.save
          render json: BxBlockAdmin::BannerSerializer.new(@banner), status: :ok
        else
          render json: { errors: @banner.errors.full_messages }, status: 400
        end
      end

      def update_banner
        @banner = BxBlockBanner::Banner.find(params[:id])

        if @banner.update(banner_params)
          render(json: @banner,status: :ok, message: "Banner updated successfully")
        else
          render(json:{ error: "No banner found"}, status:404)
        end
      end

      def destroy_banner
        @banner = BxBlockBanner::Banner.find(params[:id])

        if @banner.destroy
          render json: { message: "Banner destroyed successfully", success: true}
        else
          render(json:{ error: "No banner found"}, status:404)
        end
      end

      def show
        begin
          @brand_setting = BxBlockStoreProfile::BrandSetting.find(params[:id])
          render(json: BrandSettingSerializer.new(@brand_setting).serializable_hash,status: :ok)
        rescue 
          render(json: { error: "No brand settings found" }, status:404)
        end
      end

      def  get_country_by_currency
        if params[:currency_type] == "INR"
          brand_setting_inr = BxBlockStoreProfile::BrandSetting.find_by(currency_type: "INR")
          (brand_setting_inr.present?) ? (render json: {country: brand_setting_inr.country } , status: :ok)  : (return render json: {status: :not_found})
        elsif params[:currency_type] == "uk"
          brand_setting_uk = BxBlockStoreProfile::BrandSetting.find_by(currency_type: "uk")
          (brand_setting_uk.present?) ? (render json: {country: brand_setting_uk.country } , status: :ok)  : (return render json: {status: :not_found})
        end
      end

      def update_store_detail
       @brand_setting = BxBlockStoreProfile::BrandSetting.find(params[:brand_setting_id])
        if @brand_setting
          if @brand_setting.update(update_store_detail_params)
            render json: BxBlockAdmin::StoreDetailSerializer.new(@brand_setting).serializable_hash, status: :ok
          else
            return render json: { errors: [@brand_setting.errors.full_messages.to_sentence] }, status: :unprocessable_entity
          end
        else
          render json: { errors: ["Brand setting not found."] }, status: :not_found
        end
      end

      private

      def brand_settings_params
        params.permit(:heading, :sub_heading, :contact_us_email_copy, :order_email_copy, :header_color, :common_button_color, :button_hover_color, :brand_text_color, :active_tab_color, :inactive_tab_color, :active_text_color, :inactive_text_color, :country, :currency_type, :phone_number, :fb_link, :instagram_link, :twitter_link, :youtube_link, :button_hover_text_color, :border_color, :sidebar_bg_color, :copyright_message, :wishlist_icon_color, :wishlist_btn_text_color, :order_detail_btn_color, :api_key, :auth_domain, :database_url, :project_id, :storage_bucket, :messaging_sender_id, :app_id, :measurement_id, :is_facebook_login, :is_google_login, :is_apple_login, :transparent_color, :grey_color, :black_color, :white_color, :primary_color, :background_grey_color, :extra_button_color, :header_text_color, :header_subtext_color, :background_color, :secondary_color, :secondary_button_color, :address, :gst_number, :highlight_primary_color, :highlight_secondary_color, :address_state_id, :template_selection, :color_palet, :whatsapp_number, :whatsapp_message, :navigation_item1, :navigation_item2, :is_whatsapp_integration, :city_id, :area_code)
      end

      def banner_params
        params.permit(:banner_position, :web_banner, attachments_attributes:[:id, :image,:position, :url])
      end
      
      def update_store_detail_params
        params.permit(:heading, :contact_us_email_copy, :order_email_copy, :currency_type, :phone_number, :country, :country_id, :currency_id, :address_state_id, :address, :zipcode, :is_whatsapp_integration, :whatsapp_number, :city_id, :area_code)
      end
    end
    
  end

end
