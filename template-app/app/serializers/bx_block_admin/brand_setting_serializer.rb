module BxBlockAdmin

  class BrandSettingSerializer < BuilderBase::BaseSerializer
    attributes :buttons_color, :main_texts_color, :logo_url, :common_borders_color, :highlight_primary_color, :highlight_secondary_color, :common_texts_content, :footer_content, :common_logo_src, :product_filter_slider_color, :extra_fields, :notification_keys, :template_selection, :payment_keys

    attribute :buttons_color do |button|
      regularButtonColor = button.common_button_color,
      regularTextColor = button.active_text_color,
      hoverButtonColor = button.button_hover_color,
      hoverTextColor = '#fff'    
    end
    
    attribute :main_texts_color do |obj|
      regularColorCode = obj.active_text_color,
      activeColorCode = obj.active_text_color
    end
    
    attribute :logo_url do |obj|
      return '' if !obj.logo_url.present?
      obj.logo_url[:url]
    end

    attribute :common_borders_color do
      '#3e454f'
    end

    attribute :highlight_primary_color do |obj|
      obj.highlight_primary_color
    end

    attribute :highlight_secondary_color do |obj|
      obj.highlight_secondary_color
    end

    attribute :common_texts_content do |obj|
      callUs = obj.phone_number
    end

    attribute :footer_content do |obj|
      copyright = obj.copyright_message,
      facebookSrc = obj.fb_link,
      instagramSrc = obj.instagram_link,
      twitterSrc = obj.twitter_link,
      youtubeSrc = obj.youtube_link,
      promotionBannerSrc = obj.promotion_banner_url.present? ? obj.promotion_banner_url[:url] : ' '
    end

    attribute :common_logo_src do |obj|
      return '' if !obj.logo_url.present?
      obj.logo_url[:url]
    end

    attribute :product_filter_slider_color do |obj|
      obj.sidebar_bg_color
    end

    attribute :extra_fields do |obj|
      is_facebook_login = obj.is_facebook_login
      is_google_login = obj.is_google_login
      is_apple_login = obj.is_apple_login 
      country = obj.country
      country_code = obj.country == "uk" ? 44 : 91 
      currency_type = obj.currency_type
      heading = obj.heading
      sub_heading = obj.sub_heading
    end

    attribute :template_selection do |obj|
    template_selection = obj.template_selection
    color_palet = obj.color_palet
    end

    attribute :product_crousel do
      ['Top Picks','On Sale','Recommended Products']
    end

    attribute :notification_keys do |obj|

      notification_keys= {
        firebase:{
          apiKey: obj.api_key,
          authDomain: obj.auth_domain,
          databaseURL: obj.database_url,
          projectId: obj.project_id,
          storageBucket: obj.storage_bucket,
          messagingSenderId: obj.messaging_sender_id ,
          appId: obj.app_id,
          measurementId: obj.measurement_id
        }
      }

      notification_keys
    end

    attribute :payment_keys do
      razorpay_configuration = BxBlockApiConfiguration::ApiConfiguration.find_by(configuration_type: 'razorpay')
      stripe_configuration = BxBlockApiConfiguration::ApiConfiguration.find_by(configuration_type: 'stripe')
      shiprocket_configuration = BxBlockApiConfiguration::ApiConfiguration.find_by(configuration_type: 'shiprocket')

      payment_keys = {

        razorpay: {
          api_key: razorpay_configuration&.api_key,
          secret_key: razorpay_configuration&.api_secret_key
        },
      
        ship_rocket:{
          ship_rocket_base_url: shiprocket_configuration&.ship_rocket_base_url, ship_rocket_user_email: shiprocket_configuration&.ship_rocket_user_email, ship_rocket_user_password: shiprocket_configuration&.ship_rocket_user_password
        },
      
        stripe:{
          stripe_pub_key: stripe_configuration&.api_key, 
          stripe_secret_key: stripe_configuration&.api_secret_key
        }
        
      }

      payment_keys 
    end

    attribute :shipping_keys do |obj|
      logistics_configuration = BxBlockApiConfiguration::ApiConfiguration.find_by(configuration_type: '525k')

      shipping_keys= {
        logistics: {
          oauth_site_url:logistics_configuration&.oauth_site_url ,
          base_url:logistics_configuration&.base_url, 
          client_id:logistics_configuration&.client_id ,
          client_secret:logistics_configuration&.client_id ,
          logistic_api_key:logistics_configuration&.client_id
        }
      }

      shipping_keys
    end
  end
end
