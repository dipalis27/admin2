require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::LoginsController, type: :controller do
  before :context do
    @admin_user = FactoryBot.create(:admin_user)
  end

  describe 'Login' do
    it 'returns status 200 on valid admin user login' do
      post :create, params: { 'email': @admin_user.email, 'password': @admin_user.password }
      expect(response).to have_http_status(:ok)
    end

    it 'returns a valid BuilderJsonWebToken::AdminJsonWebToken' do
      post :create, params: { 'email': @admin_user.email, 'password': @admin_user.password }
      token = JSON.parse(response.body)['token']
      decoded_token = BuilderJsonWebToken::AdminJsonWebToken.decode(token)
      expect(decoded_token.class).to be(BuilderJsonWebToken::AdminJsonWebToken)
    end

    it 'does not raises JWT decode error on decoding token' do
      post :create, params: { 'email': @admin_user.email, 'password': @admin_user.password }
      token = JSON.parse(response.body)['token']
      expect { BuilderJsonWebToken::AdminJsonWebToken.decode(token) }.not_to raise_error(JWT::DecodeError)
      expect(response).to have_http_status(:ok)
    end
    
    it 'does not raises JWT::ExpiredSignature error on decoding token' do
      post :create, params: { 'email': @admin_user.email, 'password': @admin_user.password }
      token = JSON.parse(response.body)['token']
      expect { BuilderJsonWebToken::AdminJsonWebToken.decode(token) }.not_to raise_error(JWT::ExpiredSignature)
      expect(response).to have_http_status(:ok)
    end

    it 'token will expire after 24 hrs' do
      post :create, params: { 'email': @admin_user.email, 'password': @admin_user.password }
      token = JSON.parse(response.body)['token']
      decoded_token = BuilderJsonWebToken::AdminJsonWebToken.decode(token)
      expect(decoded_token.expiration).to be <= 24.hours.from_now
    end

    it 'when admin email is invalid' do
      post :create, params: { 'email': "admininvalid@example.com", 'password': "9876543" }
      expect(response).to have_http_status(:not_found)
    end
    
    it 'when email is valid but password is invalid' do
      post :create, params: { 'email': @admin_user.email, 'password': "9876543" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
