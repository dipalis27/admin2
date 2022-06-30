FactoryBot.define do
  sequence :email do |n|
    "admin#{Time.now.to_i}_#{rand(10**4..10**5)}@example.com"
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
