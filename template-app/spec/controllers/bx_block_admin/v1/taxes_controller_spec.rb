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

      it 'response body should have data key' do
        get :index, params: @request_params
        response_body = JSON.parse response.body
        expect(response_body).to have_key("data")
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
        # expectation = HashWithIndifferentAccess.new({"errors" => ["No taxes found"]})
        # expect(JSON.parse(response.body)).to eq(expectation)
        # expect(response.status).to eq(404)
        response_body = JSON.parse response.body
        expect(response_body).to have_key("errors")
        expect(response.status).to eq(404)
      end
    end

    context 'PATCH /update' do
      context 'with a valid authorization token' do
        subject do
          tax = FactoryBot.create(:tax).attributes.except("created_at", "updated_at")
          patch :update, params: tax.merge({token: @token})
        end

        it { is_expected.to have_http_status(:success) }
      end
      
      context "with a invalid authorization token" do
        it 'returns a bad request' do
          patch :update, params: { id: 1000 }
          expect(response).to have_http_status(:bad_request)
        end  
      end
    end

    context "DELETE /destroy" do     
      context 'with a valid authorization token' do
        subject(:response) do
          tax = FactoryBot.create(:tax)
          delete :destroy, params: @request_params.merge(id: tax.id)
        end
        let(:response_body) { JSON.parse response.body }

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'expects message and success key' do
          expect(response_body).to have_key("message")
        end
      end

      context "with a invalid authorization token" do
        it 'returns a bad request' do
          delete :destroy, params: {id: 1}
          expect(response).to have_http_status(:bad_request)
        end  
      end
    end

  end
end
