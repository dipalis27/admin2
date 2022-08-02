FactoryBot.define do
  factory :default_email_setting, class: "BxBlockSettings::DefaultEmailSetting" do
    brand_name { "Brand-Name-#{Time.now.to_i}" }
    recipient_email { Faker::Internet.email }
    contact_us_email_copy_to { Faker::Internet.email }
    logo { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Logo.png'), 'image/png') }
  end
end