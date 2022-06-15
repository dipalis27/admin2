require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::ForgotPasswordsController, type: :controller do
  before :context do
    @admin_user = FactoryBot.create(:admin_user, otp_code: 1234 )
  end

  describe 'Forgot Password' do

    context 'Send Email OTP' do
      it 'sends otp on email successfully' do
        expect { post :create, params: { 'email': @admin_user.email} }.to change { BxBlockAdmin::EmailOtpMailer.deliveries.count }.by(1)
        expect(response).to have_http_status(:ok)
      end

      it 'if email is not present in the database' do
        post :create, params: { 'email': "testemail@gmail.com" }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'Validation Of OTP' do
      it 'if valid OTP is inserted' do
        post :otp_validate, params: {'otp': @admin_user.otp_code, 'email': @admin_user.email }
        expect(response.status).to eq(200) 
      end

      it 'if invalid OTP is inserted' do
        post :otp_validate, params: {'otp': 9876, 'email': @admin_user.email }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
    
    context 'Reset Password' do
      it 'if both the fields are inserted with same password' do
        @token = BuilderJsonWebToken::AdminJsonWebToken.encode(
          @admin_user.id, { token_type: 'forgot_password' } , 5.minutes.from_now
        )
        request.headers['token'] = @token
        put :reset_password, params: {'password': "Admin@123", 'password_confirmation': "Admin@123"}
        expect(response.status).to eq(200)
      end

      it 'if both the fields are inserted with different password' do
        @token = BuilderJsonWebToken::AdminJsonWebToken.encode(
          @admin_user.id, { token_type: 'forgot_password' } , 5.minutes.from_now
        )
        request.headers['token'] = @token
        put :reset_password, params: {'password': "Admin@123", 'password_confirmation': "Admin@1234"}
        expect(response.status).to eq(422)
      end
    end
  end
end
