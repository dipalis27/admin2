module BxBlockAdmin
  class StoreDetailSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :contact_us_email_copy, :order_email_copy, :sub_heading, :header_color, :common_button_color, :button_hover_color, :brand_text_color, :active_tab_color, :inactive_tab_color, :active_text_color, :inactive_text_color, :country, :currency_type, :phone_number, :fb_link, :instagram_link, :twitter_link, :youtube_link, :button_hover_text_color, :border_color, :sidebar_bg_color, :copyright_message, :wishlist_icon_color, :wishlist_btn_text_color, :order_detail_btn_color, :is_facebook_login, :is_google_login, :is_apple_login, :transparent_color, :grey_color, :black_color, :white_color, :primary_color, :background_grey_color, :extra_button_color, :header_text_color, :header_subtext_color, :background_color, :secondary_color, :secondary_button_color, :address, :gst_number, :highlight_primary_color, :highlight_secondary_color, :template_selection, :color_palet, :address_state_id, :navigation_item1, :navigation_item2, :is_whatsapp_integration, :whatsapp_number, :city_id, :area_code, :whatsapp_message, :address_line_2
    
    attribute :country do |object|
      if object.store_country.present?
        object.store_country.name
      else
        object.country
      end
    end

    attribute :country_id do |object|
      object.store_country&.id
    end

    attribute :city do |object|
      object&.city&.name
    end
  end
end
