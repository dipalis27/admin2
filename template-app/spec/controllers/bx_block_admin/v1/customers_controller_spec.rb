require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::CustomersController, type: :controller do
  before :context do
    @admin_user = FactoryBot.create(:admin_user)
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
  end

  describe 'create customer specs' do
    context 'creates a customer' do
      let (:params) {{
        "full_name": "Test User 1",
        "email": "testuser1@yopmail.com",
        "password": "Test@123",
        "activated": "true",
        "full_phone_number": "919090980808",
        "image": "data:image/gif;base64,R0lGODdhAQABAPAAAP8AAAAAACwAAAAAAQABAAACAkQBADs=",
        "delivery_addresses_attributes": [
          {
            "name": "Test Add 1",
            "flat_no": "Test 101",
            "address": "Test 101, test building",
            "address_line_2": "Test 101 1, test building",
            "city": "Test City",
            "state": "Test State",
            "country": "india",
            "zip_code": "452001",
            "phone_number": "9090980808"
          },
          {
            "name": "Test Add 2",
            "flat_no": "Test 102",
            "address": "Test 102, test building",
            "address_line_2": "Test 102 1, test building",
            "city": "Test City",
            "state": "Test State",
            "country": "india",
            "zip_code": "452001",
            "phone_number": "9090980808"
          }
        ]
      }}

      it 'create a customer successfully with status 200' do
        request.headers['token'] = @token
        post :create, params: params
        customer = AccountBlock::Account.find_by(email: 'testuser1@yopmail.com')
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::CustomerSerializer.new(customer).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 422 if email is not provided' do
        request.headers['token'] = @token
        invalid_params = params
        invalid_params[:email] = nil
        post :create, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Email can't be blank"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if email is not unique' do
        FactoryBot.create(:customer, email: "testuser1@yopmail.com")
        request.headers['token'] = @token
        post :create, params: params
        expectation = HashWithIndifferentAccess.new({'errors': ['Email has already been taken']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if password is not provided' do
        request.headers['token'] = @token
        invalid_params = params
        invalid_params[:password] = nil
        post :create, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Password can't be blank"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if full_name is not provided' do
        request.headers['token'] = @token
        invalid_params = params
        params[:full_name] = ""
        post :create, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Full name can't be blank"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if full_phone_number is not valid' do
        request.headers['token'] = @token
        invalid_params = params
        # 9 digit indian number
        invalid_params[:full_phone_number] = "91999999999"
        post :create, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Full phone number Invalid or Unrecognized Phone Number"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not allow customer creation without admin user token' do
        post :create, params: params
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'update a customer' do
      let (:params) {{
        "full_name": "Test User 1",
        "email": "testuser1@yopmail.com",
        "password": "Test@123",
        "activated": "true",
        "full_phone_number": "919090980808",
        "image": "data:image/gif;base64,R0lGODdhAQABAPAAAP8AAAAAACwAAAAAAQABAAACAkQBADs="
      }}
      
      let (:delivery_addresses_1) {{
        "name": "Test Add 1",
        "flat_no": "Test 101",
        "address": "Test 101, test building",
        "address_line_2": "Test 101 1, test building",
        "city": "Test City",
        "state": "Test State",
        "country": "india",
        "zip_code": "452001",
        "phone_number": "9090980808"
      }}
      
      let (:delivery_addresses_2) {{
        "name": "Test Add 2",
        "flat_no": "Test 102",
        "address": "Test 102, test building",
        "address_line_2": "Test 102 1, test building",
        "city": "Test City",
        "state": "Test State",
        "country": "india",
        "zip_code": "452001",
        "phone_number": "9090980808"
      }}

      before(:all) do
        @customer = FactoryBot.create(:customer)
        FactoryBot.create(:delivery_address, account: @customer)
      end

      it 'updates a customer successfully with status 200' do
        request.headers['token'] = @token
        delivery_addresses_id = @customer.delivery_addresses.first.id
        put :update, params: params.merge({ id: @customer.id })
        customer = AccountBlock::Account.find_by(id: @customer.id)
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::CustomerSerializer.new(customer).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'updates customer attributes and returns 200' do
        request.headers['token'] = @token
        put :update, params: params.merge({ id: @customer.id })
        customer = AccountBlock::Account.find_by(id: @customer.id)
        
        response_body = HashWithIndifferentAccess.new({
          "full_name": customer.full_name,
          "email": customer.email,
          "activated": customer.activated.to_s,
          "full_phone_number": customer.full_phone_number
        })
        expected = HashWithIndifferentAccess.new({
          "full_name": "Test User 1",
          "email": "testuser1@yopmail.com",
          "activated": "true",
          "full_phone_number": "919090980808"
        })

        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'updates delivery_address of the customer and returns 200' do
        request.headers['token'] = @token
        delivery_addresses = @customer.delivery_addresses.first
        put :update, params: {
          id: @customer.id, delivery_addresses_attributes: [
            delivery_addresses_1.merge({ id: delivery_addresses.id })
          ]
        }
        customer = AccountBlock::Account.find_by(id: @customer.id)
        delivery_address = delivery_addresses.reload
        response_body = HashWithIndifferentAccess.new({
          "name": delivery_address.name, "flat_no": delivery_address.flat_no,
          "address": delivery_address.address, "address_line_2": delivery_address.address_line_2,
          "city": delivery_address.city, "state": delivery_address.state,
          "country": delivery_address.country, "zip_code": delivery_address.zip_code,
          "phone_number": delivery_address.phone_number
        })
        expect(response_body).to eq(delivery_addresses_1.with_indifferent_access)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 422 if email is not unique' do
        FactoryBot.create(:customer, email: "duplicate_email@yopmail.com")
        request.headers['token'] = @token
        put :update, params: { id: @customer.id, email: "duplicate_email@yopmail.com" } 
        expectation = HashWithIndifferentAccess.new({'errors': ['Email has already been taken']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'updates password of customer and returns 200' do
        request.headers['token'] = @token
        put :update, params: { id: @customer.id, password: 'PasswordChanged@123' }
        customer = @customer.reload
        expect(customer.authenticate('PasswordChanged@123')).to eq(customer)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 404 if customer is not found' do
        request.headers['token'] = @token
        put :update, params: { id: 0 } 
        expectation = HashWithIndifferentAccess.new({'errors': ['Customer not found']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end

      it 'does not allow to fetch customers without admin user token' do
        put :update, params: params.merge({ id: @customer.id })
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'get all customers' do
      before(:all) do
        @customer1 = FactoryBot.create(:customer, email: 'testuser1@yopmail.com')
        FactoryBot.create(:delivery_address, account: @customer1)
        @customer2 = FactoryBot.create(:customer, email: 'testuser2@yopmail.com')
      end

      it 'gets all customers successfully with status 200' do
        request.headers['token'] = @token
        get :index
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::CustomerSerializer.new(AccountBlock::Account.where.not(type: 'guest_account')).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'does not fetches guest accounts' do
        request.headers['token'] = @token
        get :index
        @guest = FactoryBot.create(:customer, email: 'guestuser@yopmail.com', guest: true)
        response_body = JSON.parse(response.body).with_indifferent_access
        expect(response_body[:data].select{ |acc| acc[:id] == @guest.id.to_s }).to eq([])
        expect(response).to have_http_status(:ok)
      end

      it 'does not allow customer creation without admin user token' do
        get :index
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'get a customer' do
      before(:all) do
        @customer = FactoryBot.create(:customer, email: 'showuser@yopmail.com')
      end

      it 'gets customer successfully with status 200' do
        request.headers['token'] = @token
        get :show, params: { id: @customer.id }
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::CustomerSerializer.new(@customer).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 404 if customer is not found' do
        request.headers['token'] = @token
        put :show, params: { id: 0 } 
        expectation = HashWithIndifferentAccess.new({'errors': ['Customer not found']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end

      it 'does not allow to fetch a customer without admin user token' do
        get :show, params: { id: @customer.id }
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'destroys a customer' do
      before(:all) do
        @customer = FactoryBot.create(:customer, email: 'deleteuser@yopmail.com')
      end

      it 'gets customer successfully with status 200' do
        request.headers['token'] = @token
        delete :destroy, params: { id: @customer.id }
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = HashWithIndifferentAccess.new('messages': ['Customer has been removed'])
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 404 if customer is not found' do
        request.headers['token'] = @token
        delete :destroy, params: { id: 0 } 
        expectation = HashWithIndifferentAccess.new({'errors': ['Customer not found']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end

      it 'does not allow to fetch a customer without admin user token' do
        delete :destroy, params: { id: @customer.id }
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
