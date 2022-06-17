FactoryBot.define do
  sequence :email do |n|
    "admin#{Time.now.to_i}@example.com"
  end

  factory :admin_user, class: 'AdminUser' do
    email { generate :email }
    password { 'Builder@1234' }
    role { 'super_admin' }
    activated { true }
    otp_code { 1234 }
    otp_valid_until { Time.current + 5.minutes }
  end
end
