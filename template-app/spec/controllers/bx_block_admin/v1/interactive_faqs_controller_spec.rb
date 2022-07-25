require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::InteractiveFaqsController, type: :controller do
  
  before :context do
    @admin_user = FactoryBot.create(:admin_user, email: 'admin22@example.com', role: 'super_admin')
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }    
  end

  describe 'Help center' do
    
    context '/index' do
      it 'static page is present' do
        FactoryBot.create(:interactive_faqs)
        get :index, params: @request_params
        expect(response.status).to eq(200)
      end

      it 'static page is not present' do
        get :index, params: @request_params
        expectation = HashWithIndifferentAccess.new({"message" => "No FAQ found"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end
    end

    context '/create' do
      it 'when admin_user provide all the fields' do
        request.headers['token'] = @token
        post :create, params: {"title": Faker::Lorem.word, 'content': Faker::Lorem.sentence, 'status': "published"}
        expect(response.status).to eq(200)
      end
      
      it 'when admin_user does not provide all the fields ' do
        request.headers['token'] = @token
        post :create, params: {"title": Faker::Lorem.word, 'status': "not_published"}
        expect(JSON.parse(response.body)["errors"].count).to be >0
        expect(response.status).to eq(400)
      end
    end
    
    context '/show' do
      it 'when static page is present ' do
        @faq = FactoryBot.create(:interactive_faqs)
        request.headers['token'] = @token
        get :show, params: {"id": @faq.id}
        expect(response.status).to eq(200)
      end

      it 'when static page is not present ' do
        request.headers['token'] = @token
        get :show, params: {"id":12}
        expectation = HashWithIndifferentAccess.new({"error" => "No FAQ found"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(404)
      end
    end

    context '/update' do
      before do
        @faq = FactoryBot.create(:interactive_faqs)
      end
      it 'when admin_user provide all the fields' do
        request.headers['token'] = @token
        put :update, params: {"id": @faq.id,"title": Faker::Lorem.word, 'content': Faker::Lorem.sentence}
        expect(response.status).to eq(200)
      end
      
      it 'when static page is not present' do
        request.headers['token'] = @token
        put :update, params: {"id":45, "title": Faker::Lorem.word, 'content': Faker::Lorem.sentence}
        expectation = HashWithIndifferentAccess.new({"error" => "No FAQ found"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(404)
      end
    end

    context '/destroy' do
      before do
        @faq = FactoryBot.create(:interactive_faqs)
      end

      it 'when admin user delete the FAQ' do
        request.headers['token'] = @token
        put :destroy, params: {"id": @faq.id}
        expect(JSON.parse(response.body)["message"]).to eq("FAQ deleted successfully.")
        expect(BxBlockInteractiveFaqs::InteractiveFaqs.exists?(@faq.id)).to be false
        expect(response.status).to eq(200)
      end

      it 'when faq is not present in the database' do
        request.headers['token'] = @token
        put :destroy, params: {"id": 12}
        expectation = HashWithIndifferentAccess.new({"error" => "No FAQ found"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(404)
      end
    end
  end
end
