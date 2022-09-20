require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::PaymentsController, type: :controller do
  before :context do
    @admin_user = FactoryBot.create(:admin_user, email: 'admin292@example.com', role: 'super_admin')
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }
    @razorpay_variables_present = ENV['RAZORPAY_KEY'].present? && ENV['RAZORPAY_SECRET'].present?
    @razorpay_variables_not_present = !(ENV['RAZORPAY_KEY'].present? && ENV['RAZORPAY_SECRET'].present?)
  end

  describe 'Payment configurations Test' do

    context '/index' do
      it 'If country is india and razorpay variables are present' do
        @brand = FactoryBot.create(:brand_settings)
        @brand.country == "india" && @razorpay_variables_present
        get :index, params: @request_params
        expectation = HashWithIndifferentAccess.new({"api_key" => ENV['RAZORPAY_KEY'], "api_secret_key"=> "-", "user_name"=> ENV['USER_NAME'], "razorpay_account_id"=> ENV['RAZORPAY_ACCOUNT_ID'], "razorpay_variables"=> @razorpay_variables_present})
        response_attributes = JSON.parse(response.body)['data']['attributes']
        expect(response_attributes).to eq(expectation)
        expect(response.status).to eq(200)
      end

      it 'If country is india and razorpay variables are not present' do
        @brand = FactoryBot.create(:brand_settings)
        @brand.country == "india" && !@razorpay_variables_not_present
        get :index, params: @request_params.merge(configuration_type: 'razorpay')
        expect(response.status).to eq(200)
      end

      it 'If country is uk' do
        @brand = FactoryBot.create(:brand_settings, country: "uk")
        @brand.country == "uk"
        get :index, params: @request_params.merge(configuration_type: 'stripe')
        expect(response.status).to eq(200)
      end
    end

    context '/create' do
      it 'when admin_user provide the required fields' do
        request.headers['token'] = @token
        post :create, params: {"configuration_type": "razorpay", "api_key": Faker::Lorem.characters(number: 10), "api_secret_key": Faker::Lorem.characters(number: 10)}
        expect(response.status).to eq(200)
      end
      
      it 'when admin_user does not provide all the fields ' do
        request.headers['token'] = @token
        post :create, params: {"configuration_type": "razorpay", "api_key": nil, "api_secret_key": nil}
        expect(JSON.parse(response.body)["error"].count).to be >0
        expect(response.status).to eq(422)
      end
    end

    context '/show' do
      it 'when API is present ' do
        @api = FactoryBot.create(:api_configuration)
        request.headers['token'] = @token
        get :show, params: {"id": @api.id}
        expect(response.status).to eq(200)
      end

      it 'when static page is not present ' do
        request.headers['token'] = @token
        get :show, params: {"id":12}
        expectation = HashWithIndifferentAccess.new({"errors" => "API configuration not found"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(404)
      end
    end

    context '/update' do
      before do
        @api = FactoryBot.create(:api_configuration)
      end

      it 'when API is present in the database' do
        request.headers['token'] = @token
        put :update, params: {"id": @api.id, "configuration_type": "razorpay", 'api_key': "qwerty", 'api_secret_key': "asdfghjk"}
        expect(response.status).to eq(200)
      end
      
      it 'when API  is not present' do
        request.headers['token'] = @token
        put :update, params: {"id":98, 'api_key': "hgadf", 'api_secret_key': "zxcvbn"}
        expectation = HashWithIndifferentAccess.new({"errors" => "API configuration not found"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(404)
      end
    end
  end
  


end
