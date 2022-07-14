require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::BulkUploadsController, type: :controller do
  
  before :context do
    AdminUser.destroy_all
    @admin_user = FactoryBot.create(:admin_user, email: 'admin2@example.com', role: 'super_admin')
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
    @request_params = { token: @token, format: :json }
    @success_response_code = 200
  end

  describe 'Bulk Uploads' do
    context 'Get all bulk images' do
      it 'returns success with status 200' do
        FactoryBot.create(:brand_settings)
        get :index, params: @request_params
        expect(response.code.to_i).to eq(@success_response_code)
      end
    end

    context 'Create bulk images' do
      it 'returns success if all images are valid' do
        FactoryBot.create(:brand_settings)
        image1 = Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Logo.png'), 'image/png')
        image2 = Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Logo.png'), 'image/png')
        post :create, params: @request_params.merge!(images: [image1, image2])
        expect(response.code.to_i).to eq(@success_response_code)
      end

        FactoryBot.create(:brand_settings)
      it 'returns 400 if any image is not valid.' do
        image1 = Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Logo.png'), 'image/png')
        image2 = Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Logo.png'), 'image/png')
        post :create, params: @request_params.merge!(images: [image1, image2])
        expect(response.code.to_i).to eq(@success_response_code)
      end
    end
  end
end
