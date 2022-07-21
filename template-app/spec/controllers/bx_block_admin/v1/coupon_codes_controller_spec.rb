require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::CouponCodesController, type: :controller do
  before :context do
    @admin_user = FactoryBot.create(:admin_user)
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
  end

  describe 'coupon code specs' do
    context 'creates a coupon code' do
      let (:params) {{
        "title": "New Coupon",
        "description": "Description",
        "code": "COUP111",
        "discount_type": "percentage",
        "discount": "30",
        "valid_from": (Time.now + 1.day).strftime("%Y-%m-%d"),
        "valid_to": (Time.now + 7.day).strftime("%Y-%m-%d"),
        "min_cart_value": "10",
        "max_cart_value": "100",
        "limit": "5"
      }}

      before(:each) do
        request.headers['token'] = @token
      end

      it 'create a coupon code successfully with status 200' do
        post :create, params: params
        coupon = BxBlockCouponCodeGenerator::CouponCode.find_by(code: 'COUP111')
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::CouponCodeSerializer.new(coupon).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 422 if title is not provided' do
        invalid_params = params
        invalid_params[:title] = nil
        post :create, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Title can't be blank"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 if code is not provided' do
        invalid_params = params
        invalid_params[:code] = nil
        post :create, params: invalid_params
        expectation = HashWithIndifferentAccess.new({'errors': ["Code can't be blank"]})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not allow coupon code creation without admin user token' do
        request.headers['token'] = nil
        post :create, params: params
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'update a coupon code' do
      before(:each) do
        request.headers['token'] = @token
      end

      before(:all) do
        @coupon = FactoryBot.create(:coupon_code)
      end

      let (:params) {{
        "title": "Update Coupon Title",
        "description": "Description",
        "code": "UPDATECOUP111",
        "discount_type": "percentage",
        "discount": "30",
        "valid_from": (Time.now + 1.day).strftime("%Y-%m-%d"),
        "valid_to": (Time.now + 7.day).strftime("%Y-%m-%d"),
        "min_cart_value": "10",
        "max_cart_value": "100",
        "limit": "5"
      }}

      it 'updates a customer successfully with status 200' do
        put :update, params: params.merge({ id: @coupon.id })
        coupon = BxBlockCouponCodeGenerator::CouponCode.find_by(id: @coupon.id)
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::CouponCodeSerializer.new(coupon).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 404 if coupon is not found' do
        put :update, params: { id: 0 } 
        expectation = HashWithIndifferentAccess.new({'errors': ['Promo code not found']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end

      it 'does not allow to update coupon code without admin user token' do
        request.headers['token'] = nil
        put :update, params: params.merge({ id: @coupon.id })
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'get all coupons' do
      before(:all) do
        @coupon1 = FactoryBot.create(:coupon_code)
        @coupon2 = FactoryBot.create(:coupon_code)
      end

      before(:each) do
        request.headers['token'] = @token
      end

      it 'fetches all coupons successfully with status 200' do
        get :index
        coupons = BxBlockCouponCodeGenerator::CouponCode.order(updated_at: :desc).page(nil).per(nil)
        options = {}
        options[:meta] = {
          pagination: {
            current_page: coupons.current_page,
            next_page: coupons.next_page,
            prev_page: coupons.prev_page,
            total_pages: coupons.total_pages,
            total_count: coupons.total_count
          }
        }
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::CouponCodeSerializer.new(coupons, options).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'fetches coupons as per the pagination' do
        get :index, params: { page: 1, per_page: 1 }
        expect(JSON.parse(response.body).with_indifferent_access[:data].count).to eq(1)
      end

      it 'does not allow customer creation without admin user token' do
        request.headers['token'] = nil
        get :index
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'get a coupon' do
      before(:all) do
        @coupon = FactoryBot.create(:coupon_code)
      end

      before(:each) do
        request.headers['token'] = @token
      end

      it 'gets coupon successfully with status 200' do
        get :show, params: { id: @coupon.id }
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::CouponCodeSerializer.new(@coupon).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 404 if coupon is not found' do
        put :show, params: { id: 0 } 
        expectation = HashWithIndifferentAccess.new({'errors': ['Promo code not found']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end

      it 'does not allow to fetch a coupon without admin user token' do
        response.headers['token'] = nil
        get :show, params: { id: @coupon.id }
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'destroys a customer' do
      before(:all) do
        @coupon = FactoryBot.create(:coupon_code)
      end

      before(:each) do
        request.headers['token'] = @token
      end

      it 'destroys coupon successfully with status 200' do
        delete :destroy, params: { id: @coupon.id }
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = HashWithIndifferentAccess.new('messages': ['Promo code has been removed'])
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 404 if coupon is not found' do
        delete :destroy, params: { id: 0 } 
        expectation = HashWithIndifferentAccess.new({'errors': ['Promo code not found']})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end

      it 'does not allow to fetch a coupon without admin user token' do
        request.headers['token'] = nil
        delete :destroy, params: { id: @coupon.id }
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
