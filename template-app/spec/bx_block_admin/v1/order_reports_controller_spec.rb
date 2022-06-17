require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::OrderReportsController,
               type: :controller do
                
  before :context do
    AdminUser.destroy_all
    @admin_user = FactoryBot.create(:admin_user, password: 'correctPass')
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }
    @success_response_code = 200
  end

  describe 'Order Reports' do
    it 'returns 200 status on success' do
      get :index, params: @request_params
      result = JSON.parse(response.body)
      expect(response.code.to_i).to eq(@success_response_code)
    end
  end
end
