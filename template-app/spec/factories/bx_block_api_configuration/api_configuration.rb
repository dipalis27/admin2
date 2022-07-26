FactoryBot.define do
  factory :api_configuration, class: "BxBlockApiConfiguration::ApiConfiguration" do
    configuration_type {'shiprocket'}
    ship_rocket_user_email {'admin@example.com'}
    ship_rocket_user_password {'password'}
  end
end
