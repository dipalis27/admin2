OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

unless AdminUser.find_by_email('admin@example.com')
  AdminUser.create(email: 'admin@example.com', password: 'Builder@54321', password_confirmation: 'Builder@54321', activated: true, role: 'super_admin')
  BxBlockRoleAndPermission::AdminProfile.create(name: 'admin', phone: '1234567890', email: 'admin@example.com', admin_user_id: AdminUser.find_by_email('admin@example.com').id ) if AdminUser.find_by_email('admin@example.com').admin_profile.blank?
end

if ENV['EMAIL'].present?
  unless AdminUser.find_by_email(ENV['EMAIL'])
    email = ENV['EMAIL'].present? ? ENV['EMAIL']  : 'admin2@example.com'
    AdminUser.create(email: email, password: 'Builder@54321', password_confirmation: 'Builder@54321', activated: true, role: 'super_admin')
    BxBlockRoleAndPermission::AdminProfile.create(name: 'admin', phone: '1234567890', email: email, admin_user_id: AdminUser.find_by_email(email).id ) if AdminUser.find_by_email(email).admin_profile.blank?
  end
end

BxBlockOrderManagement::OrderStatus.find_or_create_by(name: "Placed", status: "placed", event_name: "place_order")
BxBlockOrderManagement::OrderStatus.find_or_create_by(status: "payment_failed", event_name: "payment_failed", name: "Payment Failed")
BxBlockOrderManagement::OrderStatus.find_or_create_by(status: "payment_pending", event_name: "pending_order", name: "Payment Pending")
BxBlockOrderManagement::OrderStatus.find_or_create_by(status: "confirmed", event_name: "confirm_order", name: "Confirmed")
BxBlockOrderManagement::OrderStatus.find_or_create_by(status: "delivered", event_name: "deliver_order", name: "Delivered")
BxBlockOrderManagement::OrderStatus.find_or_create_by(status: "cancelled", event_name: "cancel_order", name: "Cancelled")
BxBlockOrderManagement::OrderStatus.find_or_create_by(status: "refunded", event_name: "refund_order", name: "Refunded")
BxBlockOrderManagement::OrderStatus.find_or_create_by(status: "returned", event_name: "return_order", name: "Returned")
BxBlockOrderManagement::OrderStatus.find_or_create_by(status: "in_cart", event_name: "in_cart", name: "In Cart")
BxBlockOrderManagement::OrderStatus.find_or_create_by(status: "created", event_name: "created", name: "created")
BxBlockOrderManagement::OrderStatus.find_or_create_by(status: "in_transit", event_name: "to_transit", name: "In Transit")

tax_0 = BxBlockOrderManagement::Tax.find_or_create_by(tax_percentage: 0)
BxBlockOrderManagement::Tax.find_or_create_by(tax_percentage: 5)
BxBlockOrderManagement::Tax.find_or_create_by(tax_percentage: 10)
BxBlockOrderManagement::Tax.find_or_create_by(tax_percentage: 12)
BxBlockOrderManagement::Tax.find_or_create_by(tax_percentage: 15)
BxBlockOrderManagement::Tax.find_or_create_by(tax_percentage: 18)

# Create allowed countries and its currency
countties = YAML.load_file("#{Rails.root}/config/countries.yml")
symbols = BxBlockOrderManagement::Currency::COUNTRY_SYMBOLS
if countties.present?
  countties.each do |country|
    object = BxBlockOrderManagement::Country.find_or_create_by(code: country[0], name: country[1])
    object.create_currency(name: symbols[country[0]][0], symbol: symbols[country[0]][1]) if object.currency.nil?
  end
end
# States with their gst codes
countties = BxBlockOrderManagement::Country.all
if countties.present?
  countties.each do |country|
    if country.code.eql?('in')
      STATES_WITH_GST_CODES = [[1, 'JAMMU AND KASHMIR', 'JK'],[2, 'HIMACHAL PRADESH', 'HP'],[3, 'PUNJAB', 'PB'],[4, 'CHANDIGARH', 'CT'],[5, 'UTTARAKHAND', 'UK'],[6, 'HARYANA', 'HR'],[7, 'DELHI', 'DL'],[8, 'RAJASTHAN', 'RJ'],[9, 'UTTAR PRADESH', 'UP'],[10, 'BIHAR', 'BR'],[11, 'SIKKIM', 'SK'],[12, 'ARUNACHAL PRADESH', 'AP'],[13, 'NAGALAND', 'NL'],[14, 'MANIPUR', 'MN'],[15, 'MIZORAM', 'MZ'],[16, 'TRIPURA', 'TR'],[17, 'MEGHALAYA', 'ML'],[18, 'ASSAM', 'AS'],[19, 'WEST BENGAL', 'WB'],[20, 'JHARKHAND', 'JH'],[21, 'ODISHA', 'OR'],[22, 'CHATTISGARH', 'CT'],[23, 'MADHYA PRADESH', 'MP'],[24, 'GUJARAT', 'GJ'],[26, 'DADRA AND NAGAR HAVELI AND DAMAN AND DIU', 'DN'],[27, 'MAHARASHTRA', 'MH'],[28, 'ANDHRA PRADESH', 'AP'],[29, 'KARNATAKA', 'KA'],[30, 'GOA', 'GA'],[31, 'LAKSHADWEEP', 'LD'],[32, 'KERALA', 'KL'],[33, 'TAMIL NADU', 'TN'],[34, 'PUDUCHERRY', 'PY'],[35, 'ANDAMAN AND NICOBAR ISLANDS', 'AN'],[36, 'TELANGANA', 'TG'],[37, 'ANDHRA PRADESH', 'AP'],[38, 'LADAKH', 'LA']]
      STATES_WITH_GST_CODES.each do |state|
        address_state = BxBlockOrderManagement::AddressState.find_or_create_by(gst_code: state[0], name: state[1])
        address_state.update_columns(country_id: country.id, code: state[2].to_s.downcase) if address_state.country_id.blank?
        if address_state.cities.blank?
          cities = CS.cities(address_state.code.to_sym, address_state.country.code.to_sym)
          cities_array = []
          cities.each do |city|
            city_hash = {name: city, address_state_id: address_state.id, created_at: Time.now, updated_at: Time.now}
            cities_array << city_hash
          end
          BxBlockOrderManagement::City.insert_all(cities_array)
        end
      end
    else
      states = CS.states(country.code.to_sym)
      if states
        states.each do |state|
          address_state = country.address_states.find_or_create_by(code: state[0].to_s.downcase, name: state[1])
        end
      end
      states = country.address_states
      states.each do |state|
        if state.cities.blank?
          cities = CS.cities(state.code.to_sym, country.code.to_sym)
          if cities
            cities_array = []
            cities.each do |city|
              city_hash = {name: city, address_state_id: state.id, created_at: Time.now, updated_at: Time.now}
              cities_array << city_hash
            end
            BxBlockOrderManagement::City.insert_all(cities_array)
          end
        end
      end
    end
  end
end
delhi = BxBlockOrderManagement::AddressState.find_by(name: 'DELHI')

# Dummy data
unless BxBlockStoreProfile::BrandSetting.any?
  brand_setting = BxBlockStoreProfile::BrandSetting.new(
    heading: 'Your store', common_button_color: '#364f6b', button_hover_color: '#5e7289',
    brand_text_color: '#ffffff', active_text_color: '#ffffff', country: 'india', currency_type: 'INR',
    is_facebook_login: false, is_google_login: false, is_apple_login: false, primary_color: '#000000',
    highlight_primary_color: '#3FC1CB', highlight_secondary_color: '#FC5185', address_state: delhi
  )
  brand_setting.logo.attach(io: File.open(Rails.root.join("app", "assets", "images", "Logo.png")), filename: "Logo.jpg")

  if brand_setting.logo.attached?
    brand_setting.save!

    BxBlockCatalogue::Tag.find_or_create_by(name: 'Dummy')

    variant = BxBlockCatalogue::Variant.find_or_initialize_by(name: 'Dummy')
    if variant.new_record?
      variant.variant_properties.new(name: 'Dummy')
      variant.save!
    end

    dummy_brand = BxBlockCatalogue::Brand.find_or_create_by(name: 'Dummy')

    (1..4).each do |i|
      banner_image_count = 0
      case i
      when 1
        banner_image_count = 1
      when 2,3
        banner_image_count = 3
      when 4
        banner_image_count = 2
      end

      banner = BxBlockBanner::Banner.find_or_initialize_by(web_banner: true, banner_position: i)
      if banner.new_record?
        banner.save!(validate: false)
        (1..banner_image_count).each do |j|
          attachment = banner.attachments.new
          attachment.position = j
          attachment.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "Banner_#{i}.#{j}.png")), filename: "Banner_#{i}.#{j}.png")
          if attachment.image.attached?
            attachment.save!
          else
            banner.destroy
          end
        end
      end

      category = BxBlockCategoriesSubCategories::Category.find_or_initialize_by(name: "Category #{i}")
      if category.new_record?
        category.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "Category_#{i}.png")), filename: "Category_#{i}.jpg")
        category.save! if category.image.attached?
      end
    end

    (1..10).each do |i|
      case i
      when (1..5)
        recommended = false
      when (6..10)
        recommended = true
      end

      product = BxBlockCatalogue::Catalogue.find_or_initialize_by(
        brand_id: dummy_brand.id, name: "Product #{i}", availability: 'in_stock', stock_qty: 1,
        weight: 1.0, price: 10.0, on_sale: false, recommended: recommended, tax_id: tax_0.id
      )
      if product.new_record?
        product.save!(validate: false)
        attachment = product.attachments.new
        attachment.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "Product.png")), filename: "product_#{i}.jpg")
        if attachment.image.attached?
          attachment.save!
        else
          product.destroy
        end
      end
    end
  end
end

# Onboarding data
onboarding = BxBlockAdmin::Onboarding.first_or_create(title: "Welcome to your store’s admin panel", description: "Everything you need to set up your store the way you want it")

step_1 = BxBlockAdmin::OnboardingStep.find_or_initialize_by(step: 1)
if step_1.new_record?
  step_completion = {
    "branding": {"completion": false, "url": "/admin/brand_settings"},
    "email": {"completion": false, "url": "/admin/email_settings"},
    "app_banner": {"completion": false, "url": "/admin/app_banners"},
    "web_banner": {"completion": false, "url": "/admin/web_banners"}
  }.to_json
  step_1.assign_attributes(title: "Create your store", description: "First up, branding – add your logo, choose your colour palette and create banners.", step_completion: step_completion, onboarding: onboarding)
  step_1.image.attach(io: File.open('app/assets/images/step_1.png'), filename: 'step_1.png')
  step_1.save if step_1.image.attached?
end

step_2 = BxBlockAdmin::OnboardingStep.find_or_initialize_by(step: 2)
if step_2.new_record?
  step_completion = {
    "taxes": {"completion": true, "url": "/admin/taxes"},
    "shipping":{"completion": false, "url": "/admin/shipping_charges"},
    "third_party_services":{"completion": false, "url": "/admin/api_configurations"}
  }.to_json
  step_2.assign_attributes(title: "Set up your business", description: "Set up your payments and logistics – and then configure your mobile app.", step_completion: step_completion, onboarding: onboarding)
  step_2.image.attach(io: File.open('app/assets/images/step_2.png'), filename: 'step_2.png')
  step_2.save if step_2.image.attached?
end

step_3 = BxBlockAdmin::OnboardingStep.find_or_initialize_by(step: 3)
if step_3.new_record?
  step_completion = {
    "variants": {"completion": false, "url": "/admin/variants"},
    "brands": {"completion": false, "url": "/admin/brands"},
    "categories": {"completion": false, "url": "/admin/categories"}
  }.to_json
  step_3.assign_attributes(title: "Add your products", description: "Finally, tell us the categories, brands, colours and sizes of your products – to create your inventory.", step_completion: step_completion, onboarding: onboarding)
  step_3.image.attach(io: File.open('app/assets/images/step_3.png'), filename: 'step_3.png')
  step_3.save if step_3.image.attached?
end

# Tax amount update
BxBlockCatalogue::Catalogue.active.each do |catalogue|
  if catalogue.catalogue_variants.blank?
    if catalogue.tax_amount.nil?
      tax = catalogue.tax
      return unless tax.present?
      price = catalogue.sale_price.present? ? catalogue.sale_price : catalogue.price
      tax_value = (price.to_f * 100) / (100 + tax.tax_percentage.to_f)
      tax_charge = price - tax_value
      catalogue.tax_amount = tax_charge.round(2)
      catalogue.price_including_tax = price.to_f.round(2)
    end
  end
end

# Third party API configurations
BxBlockApiConfiguration::ApiConfiguration.find_or_create_by(configuration_type: "razorpay", api_key: "n/a", api_secret_key: "n/a")

customer_facing_email = BxBlockSettings::EmailSettingTab.find_or_create_by(name: "Customer facing emails")
admin_emails = BxBlockSettings::EmailSettingTab.find_or_create_by(name: "Admin emails")

user_account_email = BxBlockSettings::EmailSettingCategory.find_or_create_by(name: "User account emails", email_setting_tab_id: customer_facing_email.id)
order_email = BxBlockSettings::EmailSettingCategory.find_or_create_by(name: "Order emails", email_setting_tab_id: customer_facing_email.id)
notification_email = BxBlockSettings::EmailSettingCategory.find_or_create_by(name: "Notification emails", email_setting_tab_id: customer_facing_email.id)
admin_email = BxBlockSettings::EmailSettingCategory.find_or_create_by(name: "Admin emails", email_setting_tab_id: admin_emails.id)

content = YAML.load_file("#{Rails.root}/config/templates.yaml")
BxBlockSettings::EmailSetting.event_names.keys.each do |event_name|
  content_key = event_name.downcase.gsub(" ", "_")
  email_setting = BxBlockSettings::EmailSetting.find_or_initialize_by(title: event_name)
  email_setting.content = content[content_key] if email_setting.new_record?
  if ['welcome email', 'new account otp verification', 'password changed'].include?(event_name)
    email_setting.email_setting_category_id = user_account_email.id
  elsif ['new order', 'order confirmed', 'order status'].include?(event_name)
    email_setting.email_setting_category_id = order_email.id
  elsif ['product stock notification'].include?(event_name)
    email_setting.email_setting_category_id = notification_email.id
  elsif ['contact us','admin new order'].include?(event_name)
    email_setting.email_setting_category_id = admin_email.id
  end
  email_setting.event_name = event_name
  email_setting.save
end
