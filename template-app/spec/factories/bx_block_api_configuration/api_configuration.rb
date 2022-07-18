FactoryBot.define do
  factory :api_configuration, class: 'BxBlockApiConfiguration::ApiConfiguration' do
    configuration_type{'razorpay'}
    api_key{Faker::Lorem.characters(number: 10)}
    api_secret_key{Faker::Lorem.characters(number: 10)}
  end
end