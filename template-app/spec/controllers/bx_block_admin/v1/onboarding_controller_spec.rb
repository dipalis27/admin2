require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::OnboardingController, type: :controller do
  before :context do
    @admin_user = FactoryBot.create(:admin_user)
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }
    @success_response_code = 200
  end

  describe 'onboarding status' do
    describe 'onboarding' do
      context 'get onboarding current status' do
        it 'returns correct result' do
          get :index, params: @request_params
          result = JSON.parse(response.body)
          expect(response.code.to_i).to eq(@success_response_code)
        end
      end
    end
  end
end
