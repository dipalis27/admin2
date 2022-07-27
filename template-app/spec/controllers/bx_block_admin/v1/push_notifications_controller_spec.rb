require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::PushNotificationsController, type: :controller do
  describe 'Push Notifications' do
    before :context do
      @admin_user = FactoryBot.create(:admin_user, email: 'admin392@example.com', role: 'super_admin')
      @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
      @request_params = { token: @token, format: :json }    
    end

    context '/index' do
      it 'when notifications present in the database' do
        FactoryBot.create(:push_notification)
        get :index, params: @request_params
        expect(response.status).to eq(200)
      end
      
      it 'when notifications is not present in the database' do
        get :index, params: @request_params
        expectation = HashWithIndifferentAccess.new({message: "No notifications found"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end
    end

    context '/create' do
      it 'when admin_user provide the required fields' do
        request.headers['token'] = @token
        post :create, params: {"title": Faker::Lorem.word, "message": Faker::Lorem.word}
        expect(response.status).to eq(200)
      end
    end

    context '/update' do
      before do
        @notification = FactoryBot.create(:push_notification)
      end

      it 'when notification present in the database' do
        request.headers['token'] = @token
        put :update, params: {"id": @notification.id, "title": "Update Title", "message": "Update message"}
        expect(response.status).to eq(200)
      end

      it 'when notification not present in the database' do
        request.headers['token'] = @token
        put :update, params: {"id": 45, "title": "Update Title", "message": "Update message"}
        expect(response.status).to eq(404)
      end
    end

    context '/show' do
      it 'when notification is present in the database' do
        @notification = FactoryBot.create(:push_notification)
        request.headers['token'] = @token
        get :show, params: {"id": @notification.id}
        expect(response.status).to eq(200)
      end

      it 'when Notification is not present ' do
        request.headers['token'] = @token
        get :show, params: {"id":12}
        expectation = HashWithIndifferentAccess.new({"errors" => ["No notification found"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(404)
      end
    end

    context '/destroy' do
      before do
        @notification = FactoryBot.create(:push_notification)
      end

      it 'when admin user delete the notification' do
        request.headers['token'] = @token
        delete :destroy, params: {"id": @notification.id}
        expect(BxBlockNotification::PushNotification.exists?(@notification.id)).to be false
        expect(response.status).to eq(200)
      end

      it 'when notification is not present in the database' do
        request.headers['token'] = @token
        delete :destroy, params: {"id": 12}
        expectation = HashWithIndifferentAccess.new({"errors" => ["No notification found"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(404)
      end
      
    end
    
    context '/send_notification' do
      it 'when admin user send notification' do
        @notification = FactoryBot.create(:push_notification)
        request.headers['token'] = @token
        get :send_notification, params: {id: @notification.id}
        expectation = HashWithIndifferentAccess.new({"message" => "Notification sent successfully"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(200)
      end
    end
  end
end
