module ActiveAdmin::ViewsHelper
  def country_dropdown
    ActionView::Helpers::FormOptionsHelper::COUNTRIES
  end

  def store_and_billing_state_is_same?(billing_address, brand_setting)
    if brand_setting.country.to_s.downcase == 'india' && (billing_address&.address_state&.gst_code == brand_setting&.address_state&.gst_code)
      true
    else
      false
    end
  end

  def base_url
    'https://' + (ENV['HOST_URL'] || ENV['BASE_URL'] || 'http://localhost:3000')
  end

  def minio_image_url(file)
    base_url + Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) if file.present?
  end
end
