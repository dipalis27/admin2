require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::ShippingChargesController, type: :controller do
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

    context 'create' do
      it 'shipping charge if success' do
        post :create, params: @request_params
        expect(response.code.to_i).to eq(@success_response_code)
      end
    end

    context 'show' do
      it 'shipping charge if success' do
        shipping_charge = FactoryBot.create(:shipping_charge)
        get :show, params: @request_params.merge(id: shipping_charge.id)
        expect(response.code.to_i).to eq(@success_response_code)
      end

      it '422 if shipping_charge not found.' do
        shipping_charge = FactoryBot.create(:shipping_charge)
        get :show, params: @request_params.merge(id: 123)
        expect(response.code.to_i).to eq(422)
      end
    end

    context 'update' do
      it 'shipping charge if success' do
        shipping_charge = FactoryBot.create(:shipping_charge)
        put :update, params: @request_params.merge(id: shipping_charge.id, charge: 100)
        expect(response.code.to_i).to eq(@success_response_code)
      end
      it 'return 422 if shipping_charge not found.' do
        shipping_charge = FactoryBot.create(:shipping_charge)
        put :update, params: @request_params.merge(id: 123)
        expect(response.code.to_i).to eq(422)
      end
    end

    context 'destroy' do
      it 'shipping charge if success' do
        shipping_charge = FactoryBot.create(:shipping_charge)
        delete :destroy, params: @request_params.merge(id: shipping_charge.id)
        expect(response.code.to_i).to eq(@success_response_code)
      end
      it 'return 422 if shipping_charge not found.' do
        shipping_charge = FactoryBot.create(:shipping_charge)
        delete :destroy, params: @request_params.merge(id: 123)
        expect(response.code.to_i).to eq(422)
      end
    end
  end
end
