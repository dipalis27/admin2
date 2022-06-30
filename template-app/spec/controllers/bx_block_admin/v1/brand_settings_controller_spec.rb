require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::BrandSettingsController, type: :controller do

  before :context do
    @admin_user = FactoryBot.create(:admin_user, email: 'admin2@example.com', role: 'super_admin')
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }
    @success_response_code = 200
    
    # @brand_setting = FactoryBot.create(:brand_settings)
  end
  
  describe 'Brand Settings' do

    context '/index' do
      it 'brand setting is present' do
        FactoryBot.create(:brand_settings)
        get :index, params: @request_params
        expect(response.code.to_i).to eq(@success_response_code)
      end

      it 'brand setting is not present' do
        get :index, params: @request_params
        expectation = HashWithIndifferentAccess.new({"message" => "No brand setting found"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end
    end

    context '/create' do
      it 'when admin_user provide all the fields' do
        request.headers['token'] = @token
        post :create, params: {"heading": Faker::Lorem.word, "country": "uk", "phone_number": "98765432101", "logo": Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Logo.png'))}
        expect(response.status).to eq(200)
      end
      
      it 'when admin_user does not provide all the fields ' do
        request.headers['token'] = @token
        post :create, params: {"heading": Faker::Lorem.word, "country": "uk", "phone_number": "98765432101"}
        expect(JSON.parse(response.body)["errors"].count).to be >0
        expect(response.status).to eq(422)
      end
    end

    context '/show' do
      it 'when brand setting is present ' do
        @brand = FactoryBot.create(:brand_settings)
        request.headers['token'] = @token
        get :show, params: {"id": @brand.id}
        expect(response.status).to eq(200)
      end

      it 'when brand setting is not present ' do
        request.headers['token'] = @token
        get :show, params: {"id": 0}
        expectation = HashWithIndifferentAccess.new({"error" => "No brand settings found"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(404)
      end
    end

    context '/update' do
      before do
        @brand = FactoryBot.create(:brand_settings)
      end
      it 'when admin_user provide all the fields' do
        request.headers['token'] = @token
        put :update, params: {"id": @brand.id,"heading": Faker::Lorem.word, "country": "uk", "phone_number": "98765432101", "logo": Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Logo.png'))}
        expect(JSON.parse(response.body)["message"]).to eq("Brand Settings updated successfully")
        expect(response.status).to eq(200)
      end
      
      it 'when admin_user does not valid id' do
        request.headers['token'] = @token
        put :update, params: {"id": 0,"heading": Faker::Lorem.word, "country": "uk", "phone_number": "98765432101"}
        expectation = HashWithIndifferentAccess.new({"errors" => ["Brand setting not found."]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(404)
      end
    end
  end
  
end
