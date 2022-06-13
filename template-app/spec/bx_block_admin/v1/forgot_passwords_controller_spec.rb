require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::ForgotPasswordsController, type: :controller do
  before :context do
    @user = FactoryBot.create(:admin_user)
    # @otp_code = rand(1_000..9_999)
  end

  describe 'Forgot Password' do
    context '/CREATE' do
      it 'send otp on email' do
        post :create, params: { 'email': @user.email}
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
