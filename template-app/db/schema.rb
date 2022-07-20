# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_07_18_094243) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "full_phone_number"
    t.integer "country_code"
    t.bigint "phone_number"
    t.string "email"
    t.boolean "activated", default: false, null: false
    t.string "device_id"
    t.text "unique_auth_id"
    t.string "password_digest"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "full_name"
    t.boolean "guest"
    t.string "user_name"
    t.string "provider"
    t.string "uuid"
    t.text "access_token"
    t.boolean "is_notification_enabled", default: true
    t.string "stripe_id"
    t.string "subscription_id"
    t.datetime "subscription_date"
    t.text "fcm_token"
  end

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "address_states", force: :cascade do |t|
    t.string "name"
    t.string "gst_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admin_profiles", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.string "password"
    t.bigint "admin_user_id"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_confirmation"
    t.string "current_password"
    t.index ["admin_user_id"], name: "index_admin_profiles_on_admin_user_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone_number"
    t.integer "role"
    t.boolean "activated", default: false, null: false
    t.text "permissions", default: [], array: true
    t.string "name"
    t.integer "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "login_token"
    t.integer "otp_code"
    t.datetime "otp_valid_until"
    t.index ["activated"], name: "index_admin_users_on_activated"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "api_configurations", force: :cascade do |t|
    t.integer "configuration_type"
    t.string "api_key"
    t.string "api_secret_key"
    t.string "application_id"
    t.string "application_token"
    t.string "ship_rocket_base_url"
    t.string "ship_rocket_user_email"
    t.string "ship_rocket_user_password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "oauth_site_url"
    t.string "base_url"
    t.string "client_id"
    t.string "client_secret"
    t.string "logistic_api_key"
  end

  create_table "app_categories", force: :cascade do |t|
    t.bigint "app_store_requirement_id"
    t.string "product_title"
    t.string "app_category"
    t.string "review_username"
    t.string "review_password"
    t.string "review_notes"
    t.string "app_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["app_store_requirement_id"], name: "index_app_categories_on_app_store_requirement_id"
  end

  create_table "app_requirements", force: :cascade do |t|
    t.integer "requirement_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "app_store_requirements", force: :cascade do |t|
    t.string "app_name"
    t.string "short_description"
    t.string "description"
    t.string "distributed_countries"
    t.string "copyright"
    t.string "tags", default: [], array: true
    t.string "website"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country_name"
    t.string "privacy_policy_url"
    t.string "support_url"
    t.string "marketing_url"
    t.string "terms_and_conditions_url"
    t.boolean "is_paid"
    t.integer "default_price"
    t.boolean "auto_price_conversion"
    t.boolean "android_wear"
    t.boolean "google_play_for_education"
    t.boolean "us_export_laws"
    t.string "target_audience_and_content"
    t.string "phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "content_guidlines", default: true
  end

  create_table "attachments", force: :cascade do |t|
    t.string "image"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.string "attachable_type"
    t.bigint "attachable_id"
    t.integer "position"
    t.boolean "is_default"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url_type"
    t.integer "url_id"
    t.string "url"
    t.integer "category_url_id"
    t.string "title"
    t.text "subtitle"
  end

  create_table "banners", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "banner_position"
    t.boolean "web_banner", default: false
  end

  create_table "brand_settings", force: :cascade do |t|
    t.string "heading"
    t.string "sub_heading"
    t.string "header_color"
    t.string "common_button_color"
    t.string "button_hover_color"
    t.string "brand_text_color"
    t.string "active_tab_color"
    t.string "inactive_tab_color"
    t.string "active_text_color"
    t.string "inactive_text_color"
    t.integer "country"
    t.string "currency_type"
    t.string "phone_number"
    t.string "fb_link"
    t.string "instagram_link"
    t.string "twitter_link"
    t.string "youtube_link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "button_hover_text_color"
    t.string "border_color"
    t.string "sidebar_bg_color"
    t.string "copyright_message"
    t.string "wishlist_icon_color"
    t.string "wishlist_btn_text_color"
    t.string "order_detail_btn_color"
    t.string "api_key"
    t.string "auth_domain"
    t.string "database_url"
    t.string "project_id"
    t.string "storage_bucket"
    t.string "messaging_sender_id"
    t.string "app_id"
    t.string "measurement_id"
    t.boolean "is_facebook_login"
    t.boolean "is_google_login"
    t.boolean "is_apple_login"
    t.string "transparent_color"
    t.string "grey_color"
    t.string "black_color"
    t.string "white_color"
    t.string "primary_color"
    t.string "background_grey_color"
    t.string "extra_button_color"
    t.string "header_text_color"
    t.string "header_subtext_color"
    t.string "background_color"
    t.string "secondary_color"
    t.string "secondary_button_color"
    t.string "address"
    t.string "gst_number"
    t.string "highlight_primary_color"
    t.string "highlight_secondary_color"
    t.integer "template_selection", default: 0
    t.jsonb "color_palet", default: "{}"
    t.integer "address_state_id"
    t.string "navigation_item1"
    t.string "navigation_item2"
    t.boolean "is_whatsapp_integration", default: false
    t.string "zipcode"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bulk_images", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_subscriptions", force: :cascade do |t|
    t.string "subscription_package"
    t.string "subscription_period"
    t.decimal "discount"
    t.bigint "catalogue_id"
    t.string "morning_slot"
    t.string "evening_slot"
    t.string "subscription_number"
  end

  create_table "catalogue_variant_properties", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.bigint "catalogue_variant_id", null: false
    t.bigint "variant_id", null: false
    t.bigint "variant_property_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["catalogue_id"], name: "index_catalogue_variant_properties_on_catalogue_id"
    t.index ["catalogue_variant_id"], name: "index_catalogue_variant_properties_on_catalogue_variant_id"
    t.index ["variant_id"], name: "index_catalogue_variant_properties_on_variant_id"
    t.index ["variant_property_id"], name: "index_catalogue_variant_properties_on_variant_property_id"
  end

  create_table "catalogue_variants", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.decimal "price"
    t.integer "stock_qty"
    t.boolean "on_sale", default: false
    t.decimal "sale_price"
    t.decimal "discount_price"
    t.float "length"
    t.float "breadth"
    t.float "height"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "block_qty"
    t.boolean "is_default", default: false
    t.integer "sold"
    t.integer "current_availability"
    t.integer "remaining_stock"
    t.bigint "variant_property_id"
    t.decimal "tax_amount"
    t.decimal "price_including_tax"
    t.bigint "tax_id"
    t.index ["catalogue_id"], name: "index_catalogue_variants_on_catalogue_id"
    t.index ["tax_id"], name: "index_catalogue_variants_on_tax_id"
    t.index ["variant_property_id"], name: "index_catalogue_variants_on_variant_property_id"
  end

  create_table "catalogues", force: :cascade do |t|
    t.bigint "brand_id"
    t.string "name"
    t.string "sku"
    t.string "description"
    t.datetime "manufacture_date"
    t.float "length"
    t.float "breadth"
    t.float "height"
    t.integer "availability"
    t.integer "stock_qty"
    t.decimal "weight"
    t.float "price"
    t.boolean "recommended"
    t.boolean "on_sale"
    t.decimal "sale_price"
    t.decimal "discount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "block_qty"
    t.integer "sold", default: 0
    t.float "available_price"
    t.integer "status", default: 0
    t.decimal "tax_amount"
    t.decimal "price_including_tax"
    t.bigint "tax_id"
    t.index ["brand_id"], name: "index_catalogues_on_brand_id"
    t.index ["tax_id"], name: "index_catalogues_on_tax_id"
  end

  create_table "catalogues_bulk_images", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.bigint "bulk_image_id", null: false
    t.index ["bulk_image_id"], name: "index_catalogues_bulk_images_on_bulk_image_id"
    t.index ["catalogue_id"], name: "index_catalogues_bulk_images_on_catalogue_id"
  end

  create_table "catalogues_sub_categories", force: :cascade do |t|
    t.integer "catalogue_id"
    t.integer "sub_category_id"
  end

  create_table "catalogues_tags", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.bigint "tag_id", null: false
    t.index ["catalogue_id"], name: "index_catalogues_tags_on_catalogue_id"
    t.index ["tag_id"], name: "index_catalogues_tags_on_tag_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "disabled", default: false
  end

  create_table "categories_sub_categories", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "sub_category_id", null: false
    t.index ["category_id"], name: "index_categories_sub_categories_on_category_id"
    t.index ["sub_category_id"], name: "index_categories_sub_categories_on_sub_category_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "account_id"
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "purpose_of_contact"
    t.index ["account_id"], name: "index_contacts_on_account_id"
  end

  create_table "coupon_codes", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "code"
    t.string "discount_type", default: "flat"
    t.decimal "discount"
    t.date "valid_from"
    t.date "valid_to"
    t.decimal "min_cart_value"
    t.decimal "max_cart_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "limit"
  end

  create_table "courses", force: :cascade do |t|
    t.string "course_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "discription"
    t.boolean "is_private", default: false
  end

  create_table "courses_student_profiles", id: false, force: :cascade do |t|
    t.bigint "student_profile_id"
    t.bigint "course_id"
    t.index ["course_id"], name: "index_courses_student_profiles_on_course_id"
    t.index ["student_profile_id"], name: "index_courses_student_profiles_on_student_profile_id"
  end

  create_table "customer_feedbacks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "position"
    t.string "customer_name"
    t.integer "catalogue_id"
    t.boolean "is_active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dashboards", force: :cascade do |t|
    t.string "title"
    t.integer "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "default_email_settings", force: :cascade do |t|
    t.string "brand_name"
    t.string "from_email"
    t.string "recipient_email"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.string "contact_us_email_copy_to"
    t.string "send_email_copy_method"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "delivery_address_orders", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "delivery_address_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address_for"
    t.index ["delivery_address_id"], name: "index_delivery_address_orders_on_delivery_address_id"
    t.index ["order_id"], name: "index_delivery_address_orders_on_order_id"
  end

  create_table "delivery_addresses", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "address"
    t.string "name"
    t.string "flat_no"
    t.string "zip_code"
    t.string "phone_number"
    t.datetime "deleted_at"
    t.float "latitude"
    t.float "longitude"
    t.boolean "residential", default: true
    t.string "city"
    t.string "state_code"
    t.string "country_code"
    t.string "state"
    t.string "address_line_2"
    t.string "address_type", default: "home"
    t.string "address_for", default: "shipping"
    t.boolean "is_default", default: false
    t.string "landmark"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "country", default: 0, null: false
    t.integer "address_state_id"
    t.index ["account_id"], name: "index_delivery_addresses_on_account_id"
  end

  create_table "email_otps", force: :cascade do |t|
    t.string "email"
    t.integer "pin"
    t.boolean "activated", default: false, null: false
    t.datetime "valid_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "full_name"
    t.string "phone_number"
  end

  create_table "email_setting_categories", force: :cascade do |t|
    t.string "name"
    t.bigint "email_setting_tab_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email_setting_tab_id"], name: "index_email_setting_categories_on_email_setting_tab_id"
  end

  create_table "email_setting_tabs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "email_settings", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "event_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.integer "email_setting_category_id"
    t.boolean "active", default: true
    t.index ["slug"], name: "index_email_settings_on_slug", unique: true
  end

  create_table "help_centers", force: :cascade do |t|
    t.string "help_center_type"
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 1
  end

  create_table "interactive_faqs", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 1
  end

  create_table "lessons", force: :cascade do |t|
    t.string "lesson_title"
    t.string "description"
    t.string "select_type"
    t.bigint "modulee_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "youtube_url"
    t.string "text"
    t.index ["modulee_id"], name: "index_lessons_on_modulee_id"
  end

  create_table "modulees", force: :cascade do |t|
    t.string "module_title"
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_modulees_on_course_id"
  end

  create_table "notification_groups", force: :cascade do |t|
    t.integer "group_type"
    t.string "group_name"
    t.bigint "notification_setting_id", null: false
    t.integer "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["notification_setting_id"], name: "index_notification_groups_on_notification_setting_id"
  end

  create_table "notification_settings", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notification_subgroups", force: :cascade do |t|
    t.integer "subgroup_type"
    t.string "subgroup_name"
    t.bigint "notification_group_id", null: false
    t.integer "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["notification_group_id"], name: "index_notification_subgroups_on_notification_group_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "source"
    t.integer "source_id"
    t.string "message"
    t.string "title"
    t.bigint "account_id"
    t.boolean "is_read", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_notifications_on_account_id"
  end

  create_table "onboarding_steps", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "step"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "onboarding_id"
    t.jsonb "step_completion"
    t.index ["onboarding_id"], name: "index_onboarding_steps_on_onboarding_id"
  end

  create_table "onboardings", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "dismissed", default: false, null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.integer "quantity"
    t.decimal "unit_price"
    t.decimal "total_price"
    t.decimal "old_unit_price"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "catalogue_id", null: false
    t.bigint "catalogue_variant_id"
    t.integer "order_status_id"
    t.datetime "placed_at"
    t.datetime "confirmed_at"
    t.datetime "in_transit_at"
    t.datetime "delivered_at"
    t.datetime "cancelled_at"
    t.datetime "refunded_at"
    t.boolean "manage_placed_status", default: false
    t.boolean "manage_cancelled_status", default: false
    t.string "subscription_package"
    t.string "subscription_period"
    t.integer "subscription_quantity"
    t.string "preferred_delivery_slot"
    t.decimal "subscription_discount"
    t.decimal "basic_amount"
    t.decimal "tax_amount"
    t.index ["catalogue_id"], name: "index_order_items_on_catalogue_id"
    t.index ["catalogue_variant_id"], name: "index_order_items_on_catalogue_variant_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "order_statuses", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.boolean "active", default: true
    t.string "event_name"
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "order_trackings", force: :cascade do |t|
    t.string "parent_type"
    t.bigint "parent_id"
    t.integer "tracking_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_type", "parent_id"], name: "index_order_trackings_on_parent_type_and_parent_id"
  end

  create_table "order_transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "order_id", null: false
    t.string "charge_id"
    t.integer "amount"
    t.string "currency"
    t.string "charge_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "pending"
    t.string "razorpay_order_id"
    t.string "payment_id"
    t.string "razorpay_signature"
    t.string "payment_provider"
    t.string "stripe_payment_id"
    t.index ["account_id"], name: "index_order_transactions_on_account_id"
    t.index ["order_id"], name: "index_order_transactions_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "order_number"
    t.float "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.bigint "coupon_code_id"
    t.bigint "delivery_address_id"
    t.decimal "sub_total", default: "0.0"
    t.decimal "total", default: "0.0"
    t.string "status"
    t.decimal "applied_discount", default: "0.0"
    t.text "cancellation_reason"
    t.datetime "order_date"
    t.boolean "is_gift", default: false
    t.datetime "placed_at"
    t.datetime "confirmed_at"
    t.datetime "in_transit_at"
    t.datetime "delivered_at"
    t.datetime "cancelled_at"
    t.datetime "refunded_at"
    t.string "source"
    t.string "shipment_id"
    t.string "delivery_charges"
    t.string "tracking_url"
    t.datetime "schedule_time"
    t.datetime "payment_failed_at"
    t.datetime "returned_at"
    t.decimal "tax_charges", default: "0.0"
    t.integer "deliver_by"
    t.string "tracking_number"
    t.boolean "is_error", default: false
    t.string "delivery_error_message"
    t.datetime "payment_pending_at"
    t.integer "order_status_id"
    t.boolean "is_group", default: true
    t.boolean "is_availability_checked", default: false
    t.decimal "shipping_charge"
    t.decimal "shipping_discount"
    t.decimal "shipping_net_amt"
    t.decimal "shipping_total"
    t.float "total_tax"
    t.string "razorpay_order_id"
    t.string "length"
    t.string "breadth"
    t.string "height"
    t.string "weight"
    t.string "ship_rocket_order_id"
    t.string "ship_rocket_shipment_id"
    t.string "ship_rocket_status"
    t.string "ship_rocket_status_code"
    t.string "ship_rocket_onboarding_completed_now"
    t.string "ship_rocket_awb_code"
    t.string "ship_rocket_courier_company_id"
    t.string "ship_rocket_courier_name"
    t.boolean "logistics_ship_rocket_enabled", default: false
    t.datetime "availability_checked_at"
    t.boolean "is_blocked"
    t.boolean "is_subscribed"
    t.string "stripe_payment_method_id"
    t.string "pdf_invoice_url"
    t.index ["account_id"], name: "index_orders_on_account_id"
    t.index ["coupon_code_id"], name: "index_orders_on_coupon_code_id"
  end

  create_table "product_notifies", force: :cascade do |t|
    t.bigint "catalogue_variant_id"
    t.bigint "account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "catalogue_id"
    t.index ["account_id"], name: "index_product_notifies_on_account_id"
    t.index ["catalogue_id"], name: "index_product_notifies_on_catalogue_id"
    t.index ["catalogue_variant_id"], name: "index_product_notifies_on_catalogue_variant_id"
  end

  create_table "push_notifications", force: :cascade do |t|
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
  end

  create_table "qr_codes", force: :cascade do |t|
    t.integer "code_type"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "recent_searches", force: :cascade do |t|
    t.string "search_term"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "search_id"
    t.string "search_type"
    t.integer "result_count"
    t.integer "user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "catalogue_id"
    t.string "comment"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id", null: false
    t.bigint "order_id"
    t.bigint "order_item_id"
    t.boolean "is_published"
    t.index ["account_id"], name: "index_reviews_on_account_id"
    t.index ["catalogue_id"], name: "index_reviews_on_catalogue_id"
    t.index ["order_id"], name: "index_reviews_on_order_id"
    t.index ["order_item_id"], name: "index_reviews_on_order_item_id"
  end

  create_table "shipping_charges", force: :cascade do |t|
    t.decimal "below"
    t.decimal "charge"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sms_otps", force: :cascade do |t|
    t.string "full_phone_number"
    t.integer "pin"
    t.boolean "activated", default: false, null: false
    t.datetime "valid_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "full_name"
  end

  create_table "social_auths", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "secret"
    t.bigint "account_id", null: false
    t.string "token"
    t.string "display_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_social_auths_on_account_id"
  end

  create_table "student_profiles", force: :cascade do |t|
    t.string "student_name"
    t.string "student_email"
    t.integer "level", default: 0
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "category_id"
    t.boolean "disabled", default: false
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  create_table "subscription_orders", force: :cascade do |t|
    t.bigint "order_item_id"
    t.datetime "delivery_date"
    t.integer "quantity"
    t.string "status"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "taxes", force: :cascade do |t|
    t.float "tax_percentage"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "trackings", force: :cascade do |t|
    t.string "status"
    t.string "tracking_number"
    t.datetime "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "variant_properties", force: :cascade do |t|
    t.bigint "variant_id", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["variant_id"], name: "index_variant_properties_on_variant_id"
  end

  create_table "variant_types", force: :cascade do |t|
    t.string "variant_type"
    t.string "value"
    t.bigint "catalogue_id"
    t.bigint "catalogue_variant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["catalogue_id"], name: "index_variant_types_on_catalogue_id"
    t.index ["catalogue_variant_id"], name: "index_variant_types_on_catalogue_variant_id"
  end

  create_table "variants", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "wishlist_items", force: :cascade do |t|
    t.bigint "catalogue_id"
    t.bigint "wishlist_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "catalogue_variant_id"
    t.index ["catalogue_id"], name: "index_wishlist_items_on_catalogue_id"
    t.index ["catalogue_variant_id"], name: "index_wishlist_items_on_catalogue_variant_id"
    t.index ["wishlist_id"], name: "index_wishlist_items_on_wishlist_id"
  end

  create_table "wishlists", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_wishlists_on_account_id"
  end

  create_table "zipcodes", force: :cascade do |t|
    t.string "code"
    t.boolean "activated", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "charge", default: "0.0"
    t.decimal "price_less_than", default: "0.0"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "catalogue_variant_properties", "catalogue_variants"
  add_foreign_key "catalogue_variant_properties", "catalogues"
  add_foreign_key "catalogue_variant_properties", "variant_properties"
  add_foreign_key "catalogue_variant_properties", "variants"
  add_foreign_key "catalogue_variants", "catalogues"
  add_foreign_key "catalogue_variants", "taxes"
  add_foreign_key "catalogue_variants", "variant_properties"
  add_foreign_key "catalogues", "brands"
  add_foreign_key "catalogues", "taxes"
  add_foreign_key "catalogues_bulk_images", "bulk_images"
  add_foreign_key "catalogues_bulk_images", "catalogues"
  add_foreign_key "catalogues_tags", "catalogues"
  add_foreign_key "catalogues_tags", "tags"
  add_foreign_key "categories_sub_categories", "categories"
  add_foreign_key "categories_sub_categories", "sub_categories"
  add_foreign_key "delivery_address_orders", "delivery_addresses"
  add_foreign_key "delivery_address_orders", "orders"
  add_foreign_key "delivery_addresses", "accounts"
  add_foreign_key "email_setting_categories", "email_setting_tabs"
  add_foreign_key "lessons", "modulees"
  add_foreign_key "modulees", "courses"
  add_foreign_key "notification_groups", "notification_settings"
  add_foreign_key "notification_subgroups", "notification_groups"
  add_foreign_key "notifications", "accounts"
  add_foreign_key "onboarding_steps", "onboardings"
  add_foreign_key "order_items", "catalogue_variants"
  add_foreign_key "order_items", "catalogues"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_transactions", "accounts"
  add_foreign_key "order_transactions", "orders"
  add_foreign_key "product_notifies", "accounts"
  add_foreign_key "product_notifies", "catalogue_variants"
  add_foreign_key "product_notifies", "catalogues"
  add_foreign_key "reviews", "accounts"
  add_foreign_key "reviews", "catalogues"
  add_foreign_key "reviews", "order_items"
  add_foreign_key "reviews", "orders"
  add_foreign_key "social_auths", "accounts"
  add_foreign_key "variant_properties", "variants"
  add_foreign_key "variant_types", "catalogue_variants"
  add_foreign_key "variant_types", "catalogues"
  add_foreign_key "wishlist_items", "catalogue_variants"
  add_foreign_key "wishlist_items", "wishlists"
  add_foreign_key "wishlists", "accounts"
end
