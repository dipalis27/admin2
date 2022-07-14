FactoryBot.define do
  sequence :customer_email do |n|
    "customer#{Time.now.to_i}@example.com"
  end

  sequence :customer_phone_number do |n|
    "+9199999" + rand(10**4..10**5).to_s
  end

  factory :customer, class: 'AccountBlock::Account' do
    email { generate :customer_email }
    type { 'EmailAccount' }
    password { 'Builder@1234' }
    full_name { 'customer account' }
    activated { true }
    guest { false }
    full_phone_number { generate :customer_phone_number }
    image { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Bold.jpg'), 'image/jpg') }
  end
end
