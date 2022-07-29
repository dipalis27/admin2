FactoryBot.define do
  factory :api_configuration, class: 'BxBlockApiConfiguration::ApiConfiguration' do
    configuration_type{'razorpay'}
    api_key{Faker::Lorem.characters(number: 10)}
    api_secret_key{Faker::Lorem.characters(number: 10)}
    ship_rocket_user_email {'admin@example.com'}
    ship_rocket_user_password {'password'}
  end
end
