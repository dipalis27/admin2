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
      let (:create_params) {{
        "categories": [
          {
            "name": "New Category",
            "disabled": false,
            "image": "data:image/gif;base64,R0lGODdhAQABAPAAAP8AAAAAACwAAAAAAQABAAACAkQBADs=",
            "sub_categories_attributes": [
              {
                "name": "New Sub Category",
                "image": "data:image/gif;base64,R0lGODdhAQABAPAAAP8AAAAAACwAAAAAAQABAAACAkQBADs=",
                "disabled": false
              }
            ]
          }
        ]
      }}

      before :each do
        request.headers['token'] = @token
      end

      it 'when admin creates a category with correct params it returns 200' do
        post :create, params: create_params
        category = BxBlockCategoriesSubCategories::Category.find_by(name: 'New Category')
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse ({ categories: BxBlockAdmin::CategorySerializer.new([category]).serializable_hash, errors: [] }).to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'when admin updates a category with correct params it returns 200' do
        category = FactoryBot.create(:category, name: 'New Category')
        post :create, params: { "categories": [{ "id": category.id, "name": 'Updated category name' }]}
        expect(category.reload.name).to eq("Updated category name")
        expect(response).to have_http_status(:ok)
      end

      it 'when admin creates a sub-category with redundant name then it will not be added and it returns 200' do
        category = FactoryBot.create(:category, name: 'New Category')
        FactoryBot.create(:sub_category, name: 'New Sub Category', category: category)
        post :create, params: { "categories": [{ "id": category.id, "sub_categories_attributes": [{ 'name': 'New Sub Category' }] }]}
        expect(category.reload.sub_categories.where(name: 'New Sub Category').count).to eq(1)
        expect(response).to have_http_status(:ok)
      end

      it 'when admin creates a category with redundant name it returns 200' do
        FactoryBot.create(:category, name: 'New Category')
        post :create, params: create_params
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse ({ categories: BxBlockAdmin::CategorySerializer.new([]).serializable_hash, errors: ["Name New Category has already been taken"] }).to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'when admin deletes a category it returns 200' do
        category = FactoryBot.create(:category, name: 'New Category')
        post :create, params: { "categories": [{ "id": category.id, "_destroy": 1 }] }
        expect(BxBlockCategoriesSubCategories::Category.exists?(name: 'New Category')).to eq(false)
        expect(response).to have_http_status(:ok)
      end

      it 'when admin deletes a sub-category it returns 200' do
        category = FactoryBot.create(:category, name: 'New Category')
        sub_category = FactoryBot.create(:sub_category, name: 'New Sub Category', category: category)
        post :create, params: { "categories": [{ "id": category.id, "sub_categories_attributes": [{ 'id': sub_category.id, '_destroy': 1 }] }]}
        expect(category.reload.sub_categories.exists?(name: 'New Sub Category')).to eq(false)
        expect(response).to have_http_status(:ok)
      end
      
      it 'does not allow to create category without admin user token' do
        request.headers['token'] = nil
        post :create, params: create_params
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
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
