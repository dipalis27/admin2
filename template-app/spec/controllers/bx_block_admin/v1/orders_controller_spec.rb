require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::OrdersController, type: :controller do

  before :context do
    AdminUser.destroy_all
    @admin_user = FactoryBot.create(:admin_user, email: 'admin4@example.com', role: 'super_admin')
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }
    @success_response_code = 200
  end

  describe 'Orders' do
    context 'index' do
      it 'returns Orders if success' do
        FactoryBot.create(:order, status: 'in_cart')
        FactoryBot.create(:order, status: 'placed')
        get :index, params: @request_params
        expect(JSON.parse(response.body)['data'].size).to eq(1)
      end
      it 'returns Orders if order match with customer name' do
        FactoryBot.create(:order, status: 'confirmed')
        get :index, params: @request_params.merge(term: 'customer')
        expect(JSON.parse(response.body)['data'].size).to eq(1)
      end
      it 'returns Orders with filters' do
        FactoryBot.create(:order, status: 'confirmed')
        filter_params = HashWithIndifferentAccess.new({"from_date": (Time.now - 1.days).strftime('%d/%m/%Y'),"to_date": Time.now.strftime('%d/%m/%Y'), "statuses": ["confirmed"]})
        get :index, params: @request_params.merge(filter: filter_params)
        expect(JSON.parse(response.body)['data'].size).to eq(1)
      end
      it 'returns Orders search with status delivered' do
        FactoryBot.create(:order, status: 'delivered')
        get :index, params: @request_params.merge(status: 'delivered')
        expect(JSON.parse(response.body)['data'].size).to eq(1)
      end
    end

    context 'show' do
      it 'returns success if order is found.' do
        sleep(5)
        order =  FactoryBot.create(:order, status: 'delivered')
        get :show, params: @request_params.merge(id: order.id)
        expect(response.code.to_i).to eq(@success_response_code)
      end
    end

    context 'update' do
      it 'returns Orders search with status delivered' do
        sleep(5)
        order =  FactoryBot.create(:order, status: 'confirmed')
        put :update, params: @request_params.merge(id: order.id, status: 'delivered')
        expect(JSON.parse(response.body)['data']['attributes']['status']).to eq('delivered')
      end
    end

    context 'download csv report' do
      it 'returns response for csv report' do
        sleep(5)
        order =  FactoryBot.create(:order, status: 'confirmed')
        get :download_csv_report, params: @request_params
        expect(response.code.to_i).to eq(@success_response_code)
      end
    end

    context 'update delivery address' do
      it 'returns success if delivery address updated' do
        sleep(5)
        order =  FactoryBot.create(:order, status: 'confirmed')
        delivery_address =  FactoryBot.create(:delivery_address)
        order.delivery_addresses << delivery_address
        put :update_delivery_address, params: @request_params.merge(order_id: order.id , id: delivery_address.id, state: 'Madhya Pradesh')
        expect(response.code.to_i).to eq(@success_response_code)
      end
    end
  end
end
