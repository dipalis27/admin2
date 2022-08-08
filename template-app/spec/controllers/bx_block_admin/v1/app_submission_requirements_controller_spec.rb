require 'rails_helper'

RSpec.describe BxBlockAdmin::V1::AppSubmissionRequirementsController, type: :controller do
  before :context do
    @admin_user = FactoryBot.create(:admin_user)
    @token = BuilderJsonWebToken::AdminJsonWebToken.encode(@admin_user.id)
  end

  describe 'app requirement specs' do
    context 'create or update app requirement' do
      let (:params) {
        {
          "app_name": "App Test",
          "short_description": "Short description",
          "description": "Lets describe the app",
          "tags": ["Test 1", "Test 2"],
          "website": "https://www.google.com/",
          "email": "testfree@yopmsil.com",
          "phone": "+919999988888",
          "first_name": "Test",
          "last_name": "App",
          "country_name": "India",
          "state": "Madhya Pradesh",
          "city": "Indore",
          "postal_code": "452001",
          "address": "address",
          "privacy_policy_url": "https://www.google.com/",
          "support_url": "https://www.google.com/",
          "marketing_url": "https://www.google.com/",
          "terms_and_conditions_url": "https://www.google.com/",
          "target_audience_and_content": "hello everyone",
          "is_paid": "true",
          "default_price": "100",
          "distributed_countries": "India",
          "auto_price_conversion": "true",
          "android_wear": "true",
          "google_play_for_education": "true",
          "us_export_laws": "true",
          "copyright": "Test",
          "app_icon": "data:image/jpeg;base64,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",
          "common_feature_banner": "data:image/jpeg;base64,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",
          "app_categories_attributes": [
            {
              "app_type": "android",
              "feature_graphic": "data:image/jpeg;base64,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",
              "product_title": "Test app update",
              "app_category": "Ecom",
              "review_username": "testuser",
              "review_password": "Test@123",
              "review_notes": "Nothing new",
              "attachments_attributes": [
                {
                    "image": "data:image/jpeg;base64,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"
                }
              ]
            }
          ]
        }
      }

      before :each do
        request.headers['token'] = @token
      end

      it 'create a app requirement successfully with status 200' do
        put :update, params: params
        app_requirement = BxBlockApiConfiguration::AppSubmissionRequirement.first
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::AppSubmissionRequirementSerializer.new(app_requirement).serializable_hash.to_json
        expect(response_body).to eq(expected)
        expect(app_requirement.present?).to eq(true)
        expect(response).to have_http_status(:ok)
      end

      it 'returns 422 if required fields are not provided' do
        invalid_params = params
        invalid_params[:app_name] = invalid_params[:short_description] = invalid_params[:description] = invalid_params[:first_name] = invalid_params[:last_name] = invalid_params[:email] = invalid_params[:address] = invalid_params[:city] = invalid_params[:state] = invalid_params[:postal_code] = invalid_params[:country_name] = nil
        put :update, params: invalid_params
        error_array = ["App name can't be blank", "Short description can't be blank", "Description can't be blank", "First name can't be blank", "Last name can't be blank", "Email can't be blank", "Address can't be blank", "City can't be blank", "State can't be blank", "Postal code can't be blank", "Country name can't be blank"]
        expect(error_array - JSON.parse(response.body)["errors"]).to eq([])
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'updates a field successfully with status 200' do
        FactoryBot.create(:app_submission_requirement)
        put :update, params: { app_name: 'New app' }
        app_requirement = BxBlockApiConfiguration::AppSubmissionRequirement.first
        expect(app_requirement.app_name).to eq("New app")
        expect(response).to have_http_status(:ok)
      end

      it 'updates an app_category field successfully with status 200' do
        app_requirement = FactoryBot.create(:app_submission_requirement)
        app_category = FactoryBot.create(:app_category, app_submission_requirement: app_requirement)
        put :update, params: {
          "app_categories_attributes": [
            {
              "id": app_category.id,
              "product_title": "Category updated"
            }
          ]
        }
        app_requirement_category = BxBlockApiConfiguration::AppSubmissionRequirement.first.app_categories.first
        expect(app_requirement_category.product_title).to eq("Category updated")
        expect(response).to have_http_status(:ok)
      end

      it 'removes an app_category successfully with status 200' do
        app_requirement = FactoryBot.create(:app_submission_requirement)
        app_category = FactoryBot.create(:app_category, app_submission_requirement: app_requirement)
        expect(app_requirement.app_categories.count).to eq(1)
        put :update, params: {
          "app_categories_attributes": [
            {
              "id": app_category.id,
              "_destroy": "1"
            }
          ]
        }
        expect(app_requirement.app_categories.count).to eq(0)
        expect(response).to have_http_status(:ok)
      end

      it 'does not allow app_requirement changes without admin user token' do
        request.headers['token'] = nil
        put :update, params: params
        response_body = HashWithIndifferentAccess.new(JSON.parse(response.body))
        expected = HashWithIndifferentAccess.new({ "errors" => [{"token"=>"Invalid token"}] })
        expect(response_body).to eq(expected)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'get app_requirement' do
      before(:all) do
        @app_submission_requirement = FactoryBot.create(:app_submission_requirement)
      end

      it 'gets all customers successfully with status 200' do
        request.headers['token'] = @token
        get :index
        response_body = JSON.parse(response.body).with_indifferent_access
        expected = JSON.parse BxBlockAdmin::AppSubmissionRequirementSerializer.new(@app_submission_requirement).serializable_hash.to_json
        expect(response_body).to eq(expected)
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
  end
end
