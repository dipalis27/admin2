FactoryBot.define do
  factory :admin_user, class: 'AdminUser' do
    email { 'admin@example.com' }
    password { 'Builder@1234' }
    role { 'super_admin' }
    activated { true }
  end
end
