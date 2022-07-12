require 'spec_helper'
require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::BrandsController, type: :controller do
  before(:context) do
    @admin_user = FactoryBot.create(:admin_user)
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }
  end

  describe "Brand" do
    context "GET /index" do
      context "with a valid authentication token" do
        before { get :index, params: @request_params }
        
        it 'should returns http status as success' do
          expect(response).to have_http_status(:success)
        end

        it 'should have data key in response body' do
          response_body = JSON.parse response.body
          expect(response_body).to have_key("data")
        end
      end

      context "with a invalid authorization token" do
        it 'returns a bad request' do
          get :index
          expect(response).to have_http_status(:bad_request)
        end  
      end
    end

    context 'POST /create' do
      context 'with a valid authorization token' do
        subject { post :create, params: { name: "Brand-#{Time.now.to_i}" }.merge(@request_params) }

        it { is_expected.to have_http_status(:success) }
      end

      context "with a invalid authorization token" do
        it 'returns a bad request' do
          post :create
          expect(response).to have_http_status(:bad_request)
        end  
      end
    end

    context 'PATCH /update' do
      context 'with a valid authorization token' do
        subject do
          brand = FactoryBot.create(:brand).attributes.except("created_at", "updated_at")
          patch :update, params: brand.merge({token: @token})
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

    context 'GET /show' do      
      context 'with a valid authorization token' do
        before(:context) do
          @brand = FactoryBot.create(:brand)
        end
        let(:response) { get :show, params: @request_params.merge(id: @brand.id) }
        
        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        context 'checks for the response body' do
          let(:response_body) { JSON.parse response.body }
          let(:data) { response_body["data"].deep_symbolize_keys }
          subject(:attributes) { data[:attributes] }
          
          it 'should not contain empty body' do
            expect(response_body).not_to be_nil
          end    
          
          it 'should have data key' do
            expect(response_body).to have_key("data")
          end

          it 'should have id key in data hash' do
            expect(data).to have_key(:id)
          end

          it 'should have attributes key in data hash' do
            expect(data).to have_key(:attributes)
          end

          it { is_expected.to have_key(:name) }
        end
      end

      context "with a invalid authorization token" do
        it 'returns a bad request' do
          get :show, params: {id: 1}
          expect(response).to have_http_status(:bad_request)
        end  
      end
    end
    
    context "DELETE /destroy" do     
      context 'with a valid authorization token' do
        subject(:response) do
          brand = FactoryBot.create(:brand)
          delete :destroy, params: @request_params.merge(id: brand.id)
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
