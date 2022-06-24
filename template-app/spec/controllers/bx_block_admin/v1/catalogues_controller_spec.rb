require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::CataloguesController, type: :controller do
  
  before(:context) do
    @admin_user = FactoryBot.create(:admin_user)
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }
  end


  describe 'Catalogue' do
    context 'Get /index' do

      context "with a valid authorization token" do
        let(:response) { get :index, params: @request_params }

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        context "details of response body" do
          let(:response_body) { JSON.parse response.body }
          let(:data) { response_body["data"] }
          let(:meta) { response_body["meta"] }
        
          it 'should have data key in response' do
            expect(data).not_to be_nil
          end

          it 'should have meta key in response' do
            expect(meta).not_to be_nil
          end

          it 'should have pagination details inside meta' do
            expect(meta).not_to be_empty
            expect(meta).to have_key("pagination")
          end

          it 'pagination hash should have current_page key and its value' do
            pagination = meta["pagination"]
            expect(pagination).to have_key("current_page")
            expect(pagination["current_page"]).to be >= 1
          end

          it 'pagination hash should have next_page key and its value' do
            pagination = meta["pagination"]
            expect(pagination).to have_key("next_page")
            expect(pagination["total_count"]).to be_nil.or be >= 0
          end

          it 'pagination hash should have prev_page key and its value' do
            pagination = meta["pagination"]
            expect(pagination).to have_key("prev_page")
            expect(pagination["prev_page"]).to be_nil.or be >= 0
          end
          
          it 'pagination hash should have total_pages key and its value' do
            pagination = meta["pagination"]
            expect(pagination).to have_key("total_pages")
            expect(pagination["total_pages"]).to be >= 0
          end

          it 'pagination hash should have total_count of a records' do
            pagination = meta["pagination"]
            expect(pagination).to have_key("total_count")
            expect(pagination["total_count"]).to be >= 0
          end

        end
      end
      
      context "with a invalid authorization token" do
        it 'returns a bad request' do
          get :index
          expect(response).to have_http_status(:forbidden)
        end  
      end
  
    end  
  end

end