require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::AdminUsersController, type: :controller do
  before :context do
    @admin_user = FactoryBot.create(:admin_user)
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
  end

  before :each do
    request.headers['token'] = @token
  end

  describe 'admin user controller specs' do
    context 'get an admin user' do
      it 'gets admin details successfully with status 200' do
        get :show
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::AdminUserSerializer.new(@admin_user).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'does not allow to fetch admin details without admin user token' do
        request.headers['token'] = nil
        get :show
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'update an admin' do
      let (:params) {{
        email: 'updated_admin_mail@example.com',
        phone_number: '9898989898', name: 'Updated admin'
      }}

      it 'updates admin attributes and returns 200' do
        put :update, params: params
        admin = AdminUser.find_by_id(@admin_user.id)
        
        response_body = HashWithIndifferentAccess.new({
          "name": admin.name,
          "email": admin.email,
          "phone_number": admin.phone_number
        })
        expected = HashWithIndifferentAccess.new(params)

        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'updates an admin successfully with status 200' do
        put :update, params: params
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::AdminUserSerializer.new(@admin_user.reload).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 422 if email is not unique' do
        FactoryBot.create(:admin_user, email: "duplicate_email@yopmail.com")
        put :update, params: { email: "duplicate_email@yopmail.com" } 
        expectation = HashWithIndifferentAccess.new({'errors': ['Email has already been taken']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'updates password of customer and returns 200' do
        put :update, params: { password: 'PasswordChanged@123', password_confirmation: 'PasswordChanged@123' }
        admin = @admin_user.reload
        expect(admin.valid_password?('PasswordChanged@123')).to be(true)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 422 if password and password_confirmation does not matches' do
        put :update, params: { password: 'Password@123', password_confirmation: 'Test@123' } 
        expectation = HashWithIndifferentAccess.new({'errors': ['Passwords did not match']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not allow to fetch customers without admin user token' do
        request.headers['token'] = nil
        put :update
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'get all sub_admin users' do
      before(:all) do
        @sub_admin1 = FactoryBot.create(:admin_user, email: 'subadminuser1@yopmail.com', role: 'sub_admin')
        @sub_admin2 = FactoryBot.create(:admin_user, email: 'subadminuser2@yopmail.com', role: 'sub_admin')
      end

      it 'gets all sub_admins successfully with status 200' do
        get :sub_admin_users
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::AdminUserSerializer.new(AdminUser.sub_admin).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'do not fetches other admin accounts' do
        get :sub_admin_users
        store_admin = FactoryBot.create(:admin_user, email: 'storeadmin@example.com', role: 'store_admin')
        response_body = JSON.parse(response.body).with_indifferent_access
        expect(response_body[:data].select{ |acc| acc[:id] == store_admin.id.to_s }).to eq([])
        expect(response).to have_http_status(:ok)
      end

      it 'do not fetches for a sub admin' do
        token = BuilderJsonWebToken::AdminJsonWebToken.encode(@sub_admin1.id)
        request.headers['token'] = token
        get :sub_admin_users
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => ['Permission denied!'] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not allow customer creation without admin user token' do
        request.headers['token'] = nil
        get :sub_admin_users
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'gets a sub admin user' do
      before(:all) do
        @sub_admin = FactoryBot.create(:admin_user, email: 'subadminuser@yopmail.com', role: 'sub_admin')
      end

      it 'gets sub admin details successfully with status 200' do
        get :show_sub_admin, params: { id: @sub_admin.id }
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::AdminUserSerializer.new(@sub_admin).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 404 if sub admin user is not found' do
        get :show_sub_admin, params: { id: 0 }
        expectation = HashWithIndifferentAccess.new({'errors': ['Sub admin not found']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end

      it 'do not fetches for a sub admin' do
        token = BuilderJsonWebToken::AdminJsonWebToken.encode(@sub_admin.id)
        request.headers['token'] = token
        get :show_sub_admin, params: { id: @sub_admin.id }
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => ['Permission denied!'] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not allow to fetch admin details without admin user token' do
        request.headers['token'] = nil
        get :show_sub_admin
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'gets permission array' do
      it 'gets permission array with status 200 for super admin' do
        get :permissions
        expectation = HashWithIndifferentAccess.new({ permissions: AdminUser::PERMISSION_KEYWORDS })
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:ok)
      end

      it 'do not fetches for a sub admin' do
        sub_admin = FactoryBot.create(:admin_user, role: 'sub_admin')
        token = BuilderJsonWebToken::AdminJsonWebToken.encode(sub_admin.id)
        request.headers['token'] = token
        get :permissions
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => ['Permission denied!'] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not allow to fetch admin details without admin user token' do
        request.headers['token'] = nil
        get :permissions
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'creates a sub admin' do
      let (:params) {{
        email: 'create_sub_admin@example.com', phone_number: '9898989898',
        name: 'New Sub Admin', password: 'Test@123', password_confirmation: 'Test@123',
        permissions: ['BxBlockOrderManagement::Order', 'BxBlockCatalogue::Brand']
      }}

      it 'create a sub admin successfully with status 200' do
        post :create_sub_admin, params: params
        sub_admin = AdminUser.sub_admin.find_by_email('create_sub_admin@example.com')
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::AdminUserSerializer.new(sub_admin).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 422 if email is not provided' do
        invalid_params = params
        invalid_params[:email] = nil
        post :create_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Email can't be blank"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if email is not valid' do
        invalid_params = params
        invalid_params[:email] = 'invalidemail'
        post :create_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Email is invalid"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if email is not unique' do
        FactoryBot.create(:admin_user, role: 'sub_admin', email: "duplicate_email@example.com")
        invalid_params = params
        invalid_params[:email] = 'duplicate_email@example.com'
        post :create_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ['Email has already been taken']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if password is not provided' do
        invalid_params = params
        invalid_params[:password] = invalid_params[:password_confirmation] = nil
        post :create_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Password can't be blank"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if password confirmation does not matches' do
        invalid_params = params
        invalid_params[:password_confirmation] = 'Somethingelse'
        post :create_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Password confirmation doesn't match Password"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if name is not provided' do
        invalid_params = params
        params[:name] = nil
        post :create_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Name can't be blank"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if phone_number is not provided' do
        request.headers['token'] = @token
        invalid_params = params
        invalid_params[:phone_number] = nil
        post :create_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Phone number is not a number", "Phone number is too short (minimum is 10 characters)", "Phone number can't be blank"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if phone_number is short' do
        invalid_params = params
        invalid_params[:phone_number] = "999999999"
        post :create_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Phone number is too short (minimum is 10 characters)"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if phone_number is passed with string' do
        invalid_params = params
        invalid_params[:phone_number] = "invalidno"
        post :create_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Phone number is not a number", "Phone number is too short (minimum is 10 characters)"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if permission is invalid' do
        invalid_params = params
        invalid_params[:permissions] = ["invalid"]
        post :create_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Permissions are invalid"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'do not allow sub admin creation for a sub admin' do
        sub_admin = FactoryBot.create(:admin_user, email: 'subadminusercreate@yopmail.com', role: 'sub_admin')
        token = BuilderJsonWebToken::AdminJsonWebToken.encode(sub_admin.id)
        request.headers['token'] = token
        get :create_sub_admin, params: params
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => ['Permission denied!'] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not allow sub admin creation without admin user token' do
        request.headers['token'] = nil
        post :create_sub_admin, params: params
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'updates a sub admin' do
      let (:params) {{
        id: @sub_admin.id, email: 'updated_sub_admin@example.com',
        phone_number: '9898989898', name: 'Update Sub Admin', password: 'Test@123',
        password_confirmation: 'Test@123',
        permissions: ['BxBlockOrderManagement::Order', 'BxBlockCatalogue::Brand']
      }}

      before :all do
        @sub_admin = FactoryBot.create(:admin_user, email: 'subadminuserupdate@yopmail.com', role: 'sub_admin')
      end

      it 'updates a sub admin successfully with status 200' do
        post :update_sub_admin, params: params
        sub_admin = AdminUser.sub_admin.find_by_email('updated_sub_admin@example.com')
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::AdminUserSerializer.new(sub_admin).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 422 if email is not valid' do
        invalid_params = params
        invalid_params[:email] = 'invalidemail'
        post :update_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Email is invalid"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if email is not unique' do
        FactoryBot.create(:admin_user, role: 'sub_admin', email: "duplicate_email@example.com")
        invalid_params = params
        invalid_params[:email] = 'duplicate_email@example.com'
        post :update_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ['Email has already been taken']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if password confirmation does not matches' do
        invalid_params = params
        invalid_params[:password_confirmation] = 'Somethingelse'
        post :update_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Password confirmation doesn't match Password"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if phone_number is short' do
        invalid_params = params
        invalid_params[:phone_number] = "999999999"
        post :update_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Phone number is too short (minimum is 10 characters)"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if phone_number is passed with string' do
        invalid_params = params
        invalid_params[:phone_number] = "invalidno"
        post :update_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Phone number is not a number", "Phone number is too short (minimum is 10 characters)"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if permission is invalid' do
        invalid_params = params
        invalid_params[:permissions] = ["invalid"]
        post :update_sub_admin, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Permissions are invalid"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'do not allow sub admin updation for a sub admin' do
        token = BuilderJsonWebToken::AdminJsonWebToken.encode(@sub_admin.id)
        request.headers['token'] = token
        get :update_sub_admin, params: params
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => ['Permission denied!'] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not allow sub admin creation without admin user token' do
        request.headers['token'] = nil
        post :update_sub_admin, params: params
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'destroys a customer' do
      before(:all) do
        @sub_admin = FactoryBot.create(:admin_user, email: 'subadminuserdestroy@yopmail.com', role: 'sub_admin')
      end

      it 'destroys sub admin successfully with status 200' do
        delete :destroy_sub_admin, params: { id: @sub_admin.id }
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = HashWithIndifferentAccess.new('messages': ['Sub admin has been removed'])
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 404 if sub admin is not found' do
        delete :destroy_sub_admin, params: { id: 0 } 
        expectation = HashWithIndifferentAccess.new({'errors': ['Sub admin not found']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end

      it 'do not allow to destroy a sub admin for a sub admin' do
        token = BuilderJsonWebToken::AdminJsonWebToken.encode(@sub_admin.id)
        request.headers['token'] = token
        get :destroy_sub_admin, params: { id: @sub_admin.id }
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => ['Permission denied!'] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not allow to destroy a sub admin without admin user token' do
        request.headers['token'] = nil
        delete :destroy_sub_admin, params: { id: @sub_admin.id }
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
