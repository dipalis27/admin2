require 'rails_helper'

RSpec.describe BxBlockApiConfiguration::ApiConfiguration, type: :model do
  context 'API configurations' do
    it 'when all the fields provided with valid data' do
      api = FactoryBot.create(:api_configuration)
      expect(api).to be_valid
    end

    it 'ensures that if configuration_type is razorpay then api_key and api_secret_key should be present' do
      api = FactoryBot.build(:api_configuration, api_key: nil, api_secret_key: nil)
      expect(api).to_not be_valid
    end
  end
end
