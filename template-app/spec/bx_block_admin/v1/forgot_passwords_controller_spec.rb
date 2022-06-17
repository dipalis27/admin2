require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::ForgotPasswordsController, type: :controller do
  before :context do
    @admin_user = FactoryBot.create(:admin_user)
  end

  describe 'forgot password specs' do
    context 'generate OTP' do
      it 'sends OTP on email successfully with status 200' do
        expect { post :create, params: { 'email': @admin_user.email } }.to change { BxBlockAdmin::EmailOtpMailer.deliveries.count }.by(1)
        expectation = HashWithIndifferentAccess.new({ 'messages': ['Otp sent successfully'] })
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 404 if email is not present in the database' do
        post :create, params: { 'email': "email@invalid.com" }
        expectation = {'errors' => ['Admin user not found']}
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end

      it 'updates OTP and OTP expiration for the admin' do
        before_action_otp_data = [@admin_user.otp_code, @admin_user.otp_valid_until]
        post :create, params: { 'email': @admin_user.email }
        @admin_user = @admin_user.reload
        after_action_otp_data = [@admin_user.otp_code, @admin_user.otp_valid_until]
        expect(response).to have_http_status(:ok)
        expect(before_action_otp_data).to_not eq(after_action_otp_data)
      end

      it 'generates OTP that is valid till 5 minutes' do
        post :create, params: { 'email': @admin_user.email }
        expect(response).to have_http_status(:ok)
        expect(@admin_user.reload.otp_valid_until).to be <= 5.minutes.from_now
      end
    end

    context 'OTP validation' do
      before { @admin_user.update(otp_code: rand(1_000..9_999), otp_valid_until: Time.current + 5.minutes) }

      it 'return 200 if valid OTP is inserted' do
        post :otp_validate, params: {'otp': @admin_user.otp_code, 'email': @admin_user.email }
        expect(response).to have_http_status(:ok)
      end

      it 'gives forgot password token in response if valid OTP is inserted' do
        post :otp_validate, params: {'otp': @admin_user.otp_code, 'email': @admin_user.email }
        token = JSON.parse(response.body)['token']
        decoded_token = BuilderJsonWebToken::AdminJsonWebToken.decode(token)
        expect(decoded_token.class).to be(BuilderJsonWebToken::AdminJsonWebToken)
        expect(decoded_token.token_type).to eq('forgot_password')
        expect(response).to have_http_status(:ok)
      end

      it 'returns 422 if invalid OTP is inserted' do
        post :otp_validate, params: {'otp': 987654, 'email': @admin_user.email }
        expectation = HashWithIndifferentAccess.new({'errors' => ['Otp invalid/expired']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if OTP is expired' do
        @admin_user.update(otp_valid_until: nil)
        post :otp_validate, params: {'otp': @admin_user.otp_code, 'email': @admin_user.email }
        expectation = HashWithIndifferentAccess.new({'errors' => ['Otp invalid/expired']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 404 if email is not present in the database' do
        post :otp_validate, params: { 'otp': @admin_user.otp_code, 'email': "email@invalid.com" }
        expectation = HashWithIndifferentAccess.new({'errors' => ['Admin user not found']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end
    end
    
    context 'Reset Password' do
      it 'returns 200 if password and password_confirmation matches' do
        @token = BuilderJsonWebToken::AdminJsonWebToken.encode(
          @admin_user.id, { token_type: 'forgot_password' } , 5.minutes.from_now
        )
        request.headers['token'] = @token
        put :reset_password, params: {'password': "Admin@123", 'password_confirmation': "Admin@123"}
        expectation = HashWithIndifferentAccess.new({ 'messages': ['Password updated successfully'] })
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:ok)
      end

      it 'return 422 if password and password_confirmation does not matches' do
        @token = BuilderJsonWebToken::AdminJsonWebToken.encode(
          @admin_user.id, { token_type: 'forgot_password' } , 5.minutes.from_now
        )
        request.headers['token'] = @token
        put :reset_password, params: {'password': "Admin@123", 'password_confirmation': "Admin@1234"}
        expectation = HashWithIndifferentAccess.new({'errors' => ['Passwords did not match']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return 422 if token_type is invalid' do
        @token = BuilderJsonWebToken::AdminJsonWebToken.encode(
          @admin_user.id, { token_type: 'invalid_type' } , 5.minutes.from_now
        )
        request.headers['token'] = @token
        put :reset_password, params: {'password': "Admin@123", 'password_confirmation': "Admin@123"}
        expectation = HashWithIndifferentAccess.new({'errors' => ['Invalid token type']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return 401 if token is expired' do
        @token = BuilderJsonWebToken::AdminJsonWebToken.encode(
          @admin_user.id, { token_type: 'forgot_password' } , 1.second.ago
        )
        request.headers['token'] = @token
        put :reset_password, params: {'password': "Admin@123", 'password_confirmation': "Admin@123"}
        expectation = HashWithIndifferentAccess.new({ errors: [token: 'Token has Expired'] })
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
