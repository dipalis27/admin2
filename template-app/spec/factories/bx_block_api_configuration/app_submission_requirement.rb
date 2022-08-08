FactoryBot.define do
  factory :app_submission_requirement, class: 'BxBlockApiConfiguration::AppSubmissionRequirement' do
    app_name { "My App" }
    short_description { "Summary" }
    description { "Description" }
    tags { ["Tag 1", "Tag 2"] }
    website { "https://www.google.com/" }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    country_name { "India" }
    state { "Maharashtra" }
    city { "Mumbai" }
    postal_code { "2020202" }
    address { Faker::Address.full_address }
    privacy_policy_url { "https://www.google.com/" }
    support_url { "https://www.google.com/" }
    marketing_url { "https://www.google.com/" }
    terms_and_conditions_url { "https://www.google.com/" }
    target_audience_and_content { "Students" }
    is_paid { true }
    default_price { 100 }
    distributed_countries { "India" }
    auto_price_conversion { true }
    android_wear { true }
    google_play_for_education { true }
    us_export_laws { true }
    copyright { "Copyright" }
    app_icon { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Bold.jpg'), 'image/jpg') }
    common_feature_banner { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Bold.jpg'), 'image/jpg') }
  end
end
