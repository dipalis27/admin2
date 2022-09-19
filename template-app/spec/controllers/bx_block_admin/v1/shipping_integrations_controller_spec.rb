require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::ShippingIntegrationsController, type: :controller do
  before :context do
    AdminUser.destroy_all
    BxBlockApiConfiguration::ApiConfiguration.destroy_all
    @admin_user = FactoryBot.create(:admin_user, email: 'admin4@example.com', role: 'super_admin')
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }
    @shiprocket_variables_present = ENV['SHIPROCKET_USER_EMAIL'].present? && ENV['SHIPROCKET_USER_PASSWORD'].present?
    @shiprocket_variables_not_present = !(ENV['SHIPROCKET_USER_EMAIL'].present? && ENV['SHIPROCKET_USER_PASSWORD'].present?)
    @success_response_code = 200
  end

  describe 'api configurations' do
    context 'index' do
      it 'If country is India and shiprocket variables are present' do
        @brand = FactoryBot.create(:brand_settings)
        @brand.country == "india" && @shiprocket_variables_present
        get :index, params: @request_params
        expectation = HashWithIndifferentAccess.new({"ship_rocket_user_email" => ENV['SHIPROCKET_USER_EMAIL'], "ship_rocket_user_password"=>  ENV['SHIPROCKET_USER_PASSWORD'],  "shiprocket_variables"=> @shiprocket_variables_present})
        response_attributes = JSON.parse(response.body)['data']['attributes']
        expect(response_attributes).to eq(expectation)
        expect(response.status).to eq(200)
      end
      
      it 'If country is india and shiprocket variables are not present' do
        @brand = FactoryBot.create(:brand_settings)
        @brand.country == "india" && !@shiprocket_variables_not_present
        get :index, params: @request_params.merge(configuration_type: 'shprocket')
        expect(response.status).to eq(200)
      end

      it 'If country is uk' do
        @brand = FactoryBot.create(:brand_settings, country: "uk")
        @brand.country == "uk"
        get :index, params: @request_params.merge(configuration_type: '525k')
        expect(response.status).to eq(200)
      end
    end

    context 'create' do
      it 'api configuration if success' do
        BxBlockApiConfiguration::ApiConfiguration.destroy_all
        post :create, params: @request_params.merge(configuration_type: 'shiprocket', ship_rocket_user_email: 'admin@example.com', ship_rocket_user_password: 'password')
        expect(response.code.to_i).to eq(@success_response_code)
      end
    end

    context 'show' do
      it 'api_configuration if success' do
        api_configuration = FactoryBot.create(:api_configuration)
        get :show, params: @request_params.merge(id: api_configuration.id)
        expect(response.code.to_i).to eq(@success_response_code)
      end

      it '422 if api_configuration not found.' do
        api_configuration = FactoryBot.create(:api_configuration)
        get :show, params: @request_params.merge(id: 123)
        expect(response.code.to_i).to eq(422)
      end
    end

    context 'update' do
      it 'api_configuration if success' do
        api_configuration = FactoryBot.create(:api_configuration)
        put :update, params: @request_params.merge(id: api_configuration.id, ship_rocket_user_email: 'admin2@example.com')
        expect(response.code.to_i).to eq(@success_response_code)
      end
      it 'return 422 if api_configuration not found.' do
        api_configuration = FactoryBot.create(:api_configuration)
        put :update, params: @request_params.merge(id: 123)
        expect(response.code.to_i).to eq(422)
      end
    end

    context 'destroy' do
      it 'api_configuration if success' do
        api_configuration = FactoryBot.create(:api_configuration)
        delete :destroy, params: @request_params.merge(id: api_configuration.id)
        expect(response.code.to_i).to eq(@success_response_code)
      end
      it 'return 422 if api_configuration not found.' do
        api_configuration = FactoryBot.create(:api_configuration)
        delete :destroy, params: @request_params.merge(id: 123)
        expect(response.code.to_i).to eq(422)
      end
    end
  end
end
