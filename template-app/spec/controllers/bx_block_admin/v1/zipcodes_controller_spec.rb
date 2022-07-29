require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::ZipcodesController, type: :controller do
  before :context do
    AdminUser.destroy_all
    @admin_user = FactoryBot.create(:admin_user, email: 'admin4@example.com', role: 'super_admin')
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }
    @success_response_code = 200
  end

  describe 'Zipcodes' do
    context 'index' do
      it 'returns Zipcodes if success' do
        FactoryBot.create(:zipcode)
        get :index, params: @request_params
        expect(JSON.parse(response.body)['data'].size).to eq(1)
      end
    end

    context 'create' do
      it 'Zipcode if success' do
        post :create, params: @request_params.merge(code: '452051')
        expect(response.code.to_i).to eq(@success_response_code)
      end
    end

    context 'show' do
      it 'Zipcode if success' do
        zipcode = FactoryBot.create(:zipcode)
        get :show, params: @request_params.merge(id: zipcode.id)
        expect(response.code.to_i).to eq(@success_response_code)
      end

      it '422 if zipcode not found.' do
        zipcode = FactoryBot.create(:zipcode)
        get :show, params: @request_params.merge(id: 123)
        expect(response.code.to_i).to eq(422)
      end
    end

    context 'update' do
      it 'Zipcode if success' do
        zipcode = FactoryBot.create(:zipcode)
        put :update, params: @request_params.merge(id: zipcode.id, charge: 100)
        expect(response.code.to_i).to eq(@success_response_code)
      end
      it 'return 422 if zipcode not found.' do
        zipcode = FactoryBot.create(:zipcode)
        put :update, params: @request_params.merge(id: 123)
        expect(response.code.to_i).to eq(422)
      end
    end

    context 'destroy' do
      it 'Zipcode if success' do
        zipcode = FactoryBot.create(:zipcode)
        delete :destroy, params: @request_params.merge(id: zipcode.id)
        expect(response.code.to_i).to eq(@success_response_code)
      end
      it 'return 422 if zipcode not found.' do
        zipcode = FactoryBot.create(:zipcode)
        delete :destroy, params: @request_params.merge(id: 123)
        expect(response.code.to_i).to eq(422)
      end
    end
  end
end
