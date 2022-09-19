FactoryBot.define do
  factory :api_configuration, class: 'BxBlockApiConfiguration::ApiConfiguration' do
    configuration_type{'razorpay'}
    api_key{"n/a"}
    api_secret_key{"n/a"}
  end
end
