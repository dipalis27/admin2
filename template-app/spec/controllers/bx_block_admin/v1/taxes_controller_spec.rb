require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::TaxesController do

  before :context do
    @admin_user = FactoryBot.create(:admin_user, email: 'admin22@example.com', role: 'super_admin')
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }    
  end

  describe 'Taxes' do
    
    context '/index' do
      it 'tax is present' do
        FactoryBot.create(:tax)
        get :index, params: @request_params
        expect(response.status).to eq(200)
      end

      it 'tax is not present' do
        get :index, params: @request_params
        expectation = HashWithIndifferentAccess.new({"message" => "No tax found"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end
    end

    context '/create' do
      it 'when admin_user provide the required fields' do
        request.headers['token'] = @token
        post :create, params: {"tax_percentage": 5.0}
        expect(response.status).to eq(200)
      end
      
      it 'when admin_user does not provide all the fields ' do
        request.headers['token'] = @token
        post :create, params: {"tax_percentage": nil}
        expect(JSON.parse(response.body)["errors"].count).to be >0
        expect(response.status).to eq(422)
      end
    end

    context '/show' do
      it 'when tax is present ' do
        @tax = FactoryBot.create(:tax)
        request.headers['token'] = @token
        get :show, params: {"id": @tax.id}
        expect(response.status).to eq(200)
      end

      it 'when static page is not present ' do
        request.headers['token'] = @token
        get :show, params: {"id":12}
        expectation = HashWithIndifferentAccess.new({"error" => "No taxes found"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(404)
      end
    end
  end
end
