require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::PromoCodesController, type: :controller do

  before :context do
    @admin_user = FactoryBot.create(:admin_user, email: 'admin44@example.com', role: 'super_admin')
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }    
  end

  describe 'Promo Code' do
    
    context '/index' do
      it 'promo code is present' do
        FactoryBot.create(:coupon_code)
        get :index, params: @request_params
        expect(response.status).to eq(200)
      end

      it 'promo code is not present' do
        get :index, params: @request_params
        expectation = HashWithIndifferentAccess.new({"error" => "No promo code found"})
        expect(JSON.parse(response.body)).to eq(expectation)
        expect(response).to have_http_status(:not_found)
      end
    end

    context '/create' do
      it 'when admin_user provide all the fields' do
        request.headers['token'] = @token
        post :create, params: {"title": Faker::Lorem.word, 'description': Faker::Lorem.sentence,"code": "ABCD", "discount_type": "flat" , "discount":25 ,"valid_from": Date.today,"valid_to": Date.today+10.days,"min_cart_value": 5000,"max_cart_value":8000}
        expect(response.status).to eq(200)
      end
      
      it 'when admin_user does not provide all the fields ' do
        debugger
        request.headers['token'] = @token
        post :create, params: {"title": nil, 'description': Faker::Lorem.sentence,"code": "ABCD", "discount_type": "flat" , "discount":25 ,"valid_from": Date.today,"valid_to": nil,"min_cart_value": 5000,"max_cart_value":8000}
        expect(JSON.parse(response.body)["errors"].count).to be >0
        expect(response.status).to eq(422)
      end
    end
    
    # context '/show' do
    #   it 'when static page is present ' do
    #     @help_center = FactoryBot.create(:help_center)
    #     request.headers['token'] = @token
    #     get :show, params: {"id": @help_center.id}
    #     expect(response.status).to eq(200)
    #   end

    #   it 'when static page is not present ' do
    #     request.headers['token'] = @token
    #     get :show, params: {"id":12}
    #     expectation = HashWithIndifferentAccess.new({"error" => "No static pages found"})
    #     expect(JSON.parse(response.body)).to eq(expectation)
    #     expect(response.status).to eq(404)
    #   end
    # end

    # context '/update' do
    #   before do
    #     @help_center = FactoryBot.create(:help_center)
    #   end

    #   it 'when admin_user provide all the fields' do
    #     request.headers['token'] = @token
    #     put :update, params: {"id": @help_center.id,"title": Faker::Lorem.word, 'description': Faker::Lorem.sentence, 'help_center_type': "about_us"}
    #     expect(JSON.parse(response.body)["message"]).to eq("Static Page updated successfully")
    #     expect(response.status).to eq(200)
    #   end
      
    #   it 'when static page is not present' do
    #     request.headers['token'] = @token
    #     put :update, params: {"id":45, "title": Faker::Lorem.word, 'description': Faker::Lorem.sentence, 'help_center_type': "about_us"}
    #     expectation = HashWithIndifferentAccess.new({"errors" => ["Record not found"]})
    #     expect(JSON.parse(response.body)).to eq(expectation)
    #     expect(response.status).to eq(404)
    #   end
    # end

    # context '/destroy' do
    #   before do
    #     @help_center = FactoryBot.create(:help_center)
    #   end

    #   it 'when admin user delete the help center' do
    #     request.headers['token'] = @token
    #     put :destroy, params: {"id": @help_center.id}
    #     expect(JSON.parse(response.body)["message"]).to eq("Static page deleted successfully")
    #     expect(BxBlockHelpCenter::HelpCenter.exists?(@help_center.id)).to be false
    #     expect(response.status).to eq(200)
    #   end

    #   it 'when help center is not present in the database' do
    #     request.headers['token'] = @token
    #     put :destroy, params: {"id": 12}
    #     expectation = HashWithIndifferentAccess.new({"errors" => ["Record not found"]})
    #     expect(JSON.parse(response.body)).to eq(expectation)
    #     expect(response.status).to eq(404)
    #   end
    # end
  end

end
