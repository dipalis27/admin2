require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::CustomerFeedbacksController, type: :controller do
  before :context do
    @admin_user = FactoryBot.create(:admin_user, email: 'admin34@example.com', role: 'super_admin')
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }    
  end

  describe 'Customer feedback actions' do
    
    context '/index' do
      it 'customer feedback is present' do
        FactoryBot.create(:customer_feedback)
        get :index, params: @request_params
        expect(response.status).to eq(200)
      end

      it 'customer feedback is not present' do
        get :index, params: @request_params
        expectation = HashWithIndifferentAccess.new({"message" => "No feedbacks found"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end
    end

    context '/create' do
      it 'when admin_user provide all the fields' do
        request.headers['token'] = @token
        post :create, params: {"description": Faker::Lorem.sentence, 'customer_name': Faker::Lorem.word, "position": 1}
        expect(response.status).to eq(200)
      end
      
      it 'when admin_user does not provide all the fields ' do
        request.headers['token'] = @token
        post :create, params: {"description": nil, 'customer_name': Faker::Lorem.word, "position": 3}
        expect(JSON.parse(response.body)["errors"].count).to be >0
        expect(response.status).to eq(422)
      end
    end

    context '/show' do
      it 'when feedback is present ' do
        @feedback = FactoryBot.create(:customer_feedback)
        request.headers['token'] = @token
        get :show, params: {"id": @feedback.id}
        expect(response.status).to eq(200)
      end

      it 'when feedback is not present ' do
        request.headers['token'] = @token
        get :show, params: {"id":12}
        expectation = HashWithIndifferentAccess.new({"error" => "No feedback found"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(404)
      end
    end

    context '/update' do
      before do
        @feedback = FactoryBot.create(:customer_feedback)
      end
      it 'when admin_user provide all the fields' do
        request.headers['token'] = @token
        put :update, params: {"id": @feedback.id,"description": Faker::Lorem.sentence, 'customer_name': Faker::Lorem.word, "position": 1}
        expect(JSON.parse(response.body)["message"]).to eq("Feedback updated successfully")
        expect(response.status).to eq(200)
      end
      
      it 'when customer feedback is not present' do
        request.headers['token'] = @token
        put :update, params: {"id":45, "description": Faker::Lorem.sentence, 'customer_name': Faker::Lorem.word, "position": 1}
        expectation = HashWithIndifferentAccess.new({"errors" => ["Record not found"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(404)
      end
    end
  end
end
