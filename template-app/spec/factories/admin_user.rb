FactoryBot.define do
  factory :admin_user, class: 'AdminUser' do
    email { Faker::Internet.email }
    password { 'Builder@1234' }
    role { 'super_admin' }
    activated { true }
    otp_code { 1234 }
    otp_valid_until { Time.current + 5.minutes }
    
  end
end
