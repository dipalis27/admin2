require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::ShippingChargeController, type: :controller do

  before :context do
    AdminUser.destroy_all
    @admin_user = FactoryBot.create(:admin_user, email: 'admin4@example.com', role: 'super_admin')
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }
    @success_response_code = 200
  end

  describe 'Shipping Charges' do
    context 'index' do
      it 'returns shipping charges if success' do
        FactoryBot.create(:shipping_charge)
        get :index, params: @request_params
        expect(JSON.parse(response.body)['data'].size).to eq(1)
      end
    end
  end
end
