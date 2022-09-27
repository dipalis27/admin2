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
          expect(response).to have_http_status(:bad_request)
        end  
      end
    end
    
    context 'POST /create' do
      context 'with a valid authorization token' do
        subject do
          tax = FactoryBot.create(:tax)
          catalogue = FactoryBot.build_stubbed(:catalogue).attributes.except("id", "created_at", "updated_at").merge({tax_id: tax.id})
          post :create, params: catalogue.merge({token: @token})
        end

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
          catalogue = FactoryBot.create(:catalogue).attributes.except("created_at", "updated_at")
          patch :update, params: catalogue.merge({token: @token})
        end

        # it { is_expected.to have_http_status(:success) }
      end
      
      context "with a invalid authorization token" do
        it 'returns a bad request' do
          patch :update, params: {id: 1}
          expect(response).to have_http_status(:bad_request)
        end  
      end
    end

    context 'GET /show' do      
      context 'with a valid authorization token' do
        before(:context) do
          @catalogue = FactoryBot.create(:catalogue)
        end
        let(:response) { get :show, params: @request_params.merge(id: @catalogue.id) }
        
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
          it { is_expected.to have_key(:sku) }
          it { is_expected.to have_key(:description) }
          it { is_expected.to have_key(:manufacture_date) }
          it { is_expected.to have_key(:length) }
          it { is_expected.to have_key(:breadth) }
          it { is_expected.to have_key(:height) }
          it { is_expected.to have_key(:availability) }
          it { is_expected.to have_key(:stock_qty) }
          it { is_expected.to have_key(:weight) }
          it { is_expected.to have_key(:price) }
          it { is_expected.to have_key(:recommended) }
          it { is_expected.to have_key(:on_sale) }
          it { is_expected.to have_key(:sale_price) }
          it { is_expected.to have_key(:discount) }
          it { is_expected.to have_key(:block_qty) }
          it { is_expected.to have_key(:sold) }
          it { is_expected.to have_key(:available_price) }
          it { is_expected.to have_key(:status) }
          it { is_expected.to have_key(:tax_amount) }
          it { is_expected.to have_key(:price_including_tax) }
          it { is_expected.to have_key(:catalogue_variants_attributes) }
          it { is_expected.to have_key(:tags) }
          it { is_expected.to have_key(:brand_id) }
          it { is_expected.to have_key(:category) }
          # it { is_expected.to have_key(:subscriptions) }
          it { is_expected.to have_key(:catalogue_attachments) }        
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
          catalogue = FactoryBot.create(:catalogue)
          delete :destroy, params: @request_params.merge(id: catalogue.id)
        end
        let(:response_body) { JSON.parse response.body }

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'expects message and success key' do
          expect(response_body).to have_key("message")
          expect(response_body).to have_key("success")
        end

        it 'expects success to be true' do
          expect(response_body["success"]).to eq(true) 
        end
      end

      context "with a invalid authorization token" do
        it 'returns a bad request' do
          delete :destroy, params: {id: 1}
          expect(response).to have_http_status(:bad_request)
        end  
      end
    end

    context 'POST /one_click_upload' do
      context 'with a valid authorization token' do
        let(:request_body) do
          {
            data:
              [
                {
                  category: "Baby Care",
                  category_image_url: "https://drive.google.com/uc?export=view&id=1QefNn-V2lzbKXfVMb_Jbr0dONjRRHT3r",
                  sub_category: "Baby Food",
                  name: "Nestle Cerelac With Milk, Multigrain Dal Veg Baby Cereal (From 12 to 24 Months)",
                  description: "First prod",
                  price: 10,
                  catalogue_image_url: "https://drive.google.com/uc?export=view&id=1jhxsSGIVjaI35qCpAYbaMz_zqY5gSTPq"
                }
              ]
          }
        end

        subject do
          post :one_click_upload, params: request_body.merge({token: @token})
        end

        it { is_expected.to have_http_status(:success) }  
      end
    end
    
  end

end