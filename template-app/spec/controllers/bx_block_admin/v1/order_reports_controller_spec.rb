require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::OrderReportsController, type: :controller do

  before :context do
    AdminUser.destroy_all
    @admin_user = FactoryBot.create(:admin_user, email: 'admin4@example.com', role: 'super_admin')
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }
    @success_response_code = 200
  end

  describe 'OrderReports' do
    context 'index' do
      order = FactoryBot.create(:order, status: 'confirmed')
      it 'returns order reports if success' do
        get :index, params: @request_params
        expect(response.code.to_i).to eq(@success_response_code)
      end
    end

    context 'get_sales_chart_data' do
      it 'returns 12 months order reports sales if success' do
        get :get_sales_chart_data, params: @request_params.merge(duration: 12)
        expect(response.code.to_i).to eq(@success_response_code)
      end

      it 'returns lifetime order reports sales if success' do
        get :get_sales_chart_data, params: @request_params.merge(duration: 'lifetime')
        expect(response.code.to_i).to eq(@success_response_code)
      end

      it 'returns today order reports sales if success' do
        get :get_sales_chart_data, params: @request_params.merge(duration: 'today')
        expect(response.code.to_i).to eq(@success_response_code)
      end

      it 'returns 1 month order reports sales if success' do
        get :get_sales_chart_data, params: @request_params.merge(duration: 1)
        expect(response.code.to_i).to eq(@success_response_code)
      end
    end
  end
end