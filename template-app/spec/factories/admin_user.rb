FactoryBot.define do
  sequence :admin_email do |n|
    "admin#{Time.now.to_i}_#{rand(10**4..10**5)}@example.com"
  end

  sequence :admin_phone_number do |n|
    rand(10**9..10**10).to_s
  end

  factory :admin_user, class: 'AdminUser' do
    email { generate :admin_email }
    password { 'Builder@1234' }
    role { 'super_admin' }
    name { 'Admin User' }
    phone_number { generate :admin_phone_number }
    activated { true }
    otp_code { 1234 }
    otp_valid_until { Time.current + 5.minutes }
  end
end
