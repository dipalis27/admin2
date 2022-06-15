require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::LoginsController, type: :controller do
  before :context do
    @admin_user = FactoryBot.create(:admin_user, password: 'correctPass')
  end

  describe 'login controller specs' do
    it 'returns status 200 on valid admin user login' do
      post :create, params: { 'email': @admin_user.email, 'password': 'correctPass' }
      expect(response).to have_http_status(:ok)
    end

    it 'returns a valid BuilderJsonWebToken::AdminJsonWebToken' do
      post :create, params: { 'email': @admin_user.email, 'password': 'correctPass' }
      token = JSON.parse(response.body)['token']
      decoded_token = BuilderJsonWebToken::AdminJsonWebToken.decode(token)
      expect(decoded_token.class).to be(BuilderJsonWebToken::AdminJsonWebToken)
      expect(response).to have_http_status(:ok)
    end

    it 'does not raises JWT::DecodeError on decoding token' do
      post :create, params: { 'email': @admin_user.email, 'password': 'correctPass' }
      token = JSON.parse(response.body)['token']
      expect { BuilderJsonWebToken::AdminJsonWebToken.decode(token) }.not_to raise_error(JWT::DecodeError)
      expect(response).to have_http_status(:ok)
    end
    
    it 'does not raises JWT::ExpiredSignature on decoding token' do
      post :create, params: { 'email': @admin_user.email, 'password': 'correctPass' }
      token = JSON.parse(response.body)['token']
      expect { BuilderJsonWebToken::AdminJsonWebToken.decode(token) }.not_to raise_error(JWT::ExpiredSignature)
      expect(response).to have_http_status(:ok)
    end

    it 'will provide token that will expire after 24 hrs' do
      post :create, params: { 'email': @admin_user.email, 'password': 'correctPass' }
      token = JSON.parse(response.body)['token']
      decoded_token = BuilderJsonWebToken::AdminJsonWebToken.decode(token)
      expect(decoded_token.expiration).to be <= 24.hours.from_now
      expect(response).to have_http_status(:ok)
    end

    it 'returns 404 when admin email is invalid' do
      post :create, params: { 'email': "admininvalid@example.com", 'password': "correctPass" }
      expectation = HashWithIndifferentAccess.new({'errors' => ['Admin user not found']})
      expect(JSON.parse(response.body)).to eq(expectation)
      expect(response).to have_http_status(:not_found)
    end
    
    it 'return 422 when email is valid but password is invalid' do
      post :create, params: { 'email': @admin_user.email, 'password': "incorrectPass" }
      expectation = HashWithIndifferentAccess.new({'errors' => ['Invalid password']})
      expect(JSON.parse(response.body)).to eq(expectation)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
