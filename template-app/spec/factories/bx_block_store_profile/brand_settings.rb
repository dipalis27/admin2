FactoryBot.define do
  factory :brand_settings, class: "BxBlockStoreProfile::BrandSetting" do
    address_state_id{1}
    logo { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Logo.png'), 'image/png') }
    heading {Faker::Lorem.word}
    phone_number {9876543210}
    country {"india"}
  end
end