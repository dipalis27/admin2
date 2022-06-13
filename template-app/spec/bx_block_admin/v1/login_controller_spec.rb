require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::LoginsController, type: :controller do
    before :context do
      @user = FactoryBot.create(:admin_user, email: 'admin1@example.com', password: '123456')
    end

  describe 'Login' do
    it 'logged_in' do
      post :create, params: { 'email': @user.email, 'password': @user.password }
      expect(response.status).to eq(200)
    end
    
  end
  

end
