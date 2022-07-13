require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::CategoriesController, type: :controller do

  before :context do
    AdminUser.destroy_all
    @admin_user = FactoryBot.create(:admin_user, email: 'admin4@example.com', role: 'super_admin')
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }
    @success_response_code = 200
  end
  
  describe 'Categories' do
    context '/index' do
      it 'returns Categories if success' do
        FactoryBot.create(:category)
        get :index, params: @request_params
        expect(response.code.to_i).to eq(@success_response_code)
      end
    end

    context '/create' do
      it 'when admin provides category name returns 200' do
        request.headers['token'] = @token
        post :create, params: {"name": Faker::Lorem.name}
        expect(response.status).to eq(@success_response_code)
      end
      
      it 'when admin doest not provide category name returns 422' do
        request.headers['token'] = @token
        post :create, params: {"name": ''}
        expect(JSON.parse(response.body)["errors"].count).to be >0
        expect(response.status).to eq(422)
      end
    end

    context '/update' do
      before do
        @category = FactoryBot.create(:category)
      end
      it 'when admin provides values values returns 200' do
        request.headers['token'] = @token
        put :update, params: {id: @category.id ,"name": Faker::Lorem.name}
        expect(response.status).to eq(@success_response_code)
      end
      
      it 'when admin doest not provide invalid values returns 422' do
        request.headers['token'] = @token
        put :update, params: {id: @category.id ,"name": ''}
        expect(JSON.parse(response.body)["errors"].count).to be >0
        expect(response.status).to eq(422)
      end
    end

    context '/show' do
      it 'when category is present ' do
        @category = FactoryBot.create(:category)
        request.headers['token'] = @token
        get :show, params: {"id": @category.id}
        expect(response.status).to eq(@success_response_code)
      end

      it 'when category is not present ' do
        request.headers['token'] = @token
        get :show, params: {"id":123}
        expectation = HashWithIndifferentAccess.new({"errors" => ["Category not found"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(404)
      end
    end

    context '/destroy' do
      it 'when category is deleted it returns success ' do
        @category = FactoryBot.create(:category)
        request.headers['token'] = @token
        get :destroy, params: {"id": @category.id}
        expectation = HashWithIndifferentAccess.new({"message"=>"Category deleted successfully.", "success"=>true})
        expect(JSON.parse(response.body)).to eq(expectation)
      end

      it 'when category is not present ' do
        request.headers['token'] = @token
        get :show, params: {"id":123}
        expectation = HashWithIndifferentAccess.new({"errors" => ["Category not found"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response.status).to eq(404)
      end
    end
  end
end
