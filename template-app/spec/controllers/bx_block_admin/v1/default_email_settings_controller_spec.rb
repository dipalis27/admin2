require 'spec_helper'
require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::DefaultEmailSettingsController, type: :controller do
  before(:context) do
    @admin_user = FactoryBot.create(:admin_user)
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }
  end

  let(:default_email_setting_params) { 
    {
      brand_name: "BrandName-#{Time.now.to_i}",
      recipient_email: Faker::Internet.email,
      contact_us_email_copy_to: Faker::Internet.email,
      logo: "data:image/gif;base64,R0lGODdhAQABAPAAAP8AAAAAACwAAAAAAQABAAACAkQBADs="
    }
   }

  describe "EmailSetting" do
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
        subject { post :create, params: default_email_setting_params.merge(@request_params) }
        
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
          default_email_setting = FactoryBot.create(:default_email_setting).attributes.except("created_at", "updated_at")
          patch :update, params: default_email_setting.merge({token: @token})
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
          @default_email_setting = FactoryBot.create(:default_email_setting)
        end
        let(:response) { get :show, params: @request_params.merge(id: @default_email_setting.id) }
        
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
          
          it { is_expected.to have_key(:brand_name) }
          it { is_expected.to have_key(:from_email) }
          it { is_expected.to have_key(:recipient_email) }
          it { is_expected.to have_key(:contact_us_email_copy_to) }
          it { is_expected.to have_key(:send_email_copy_method) }
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
          default_email_setting = FactoryBot.create(:default_email_setting)
          delete :destroy, params: @request_params.merge(id: default_email_setting.id)
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