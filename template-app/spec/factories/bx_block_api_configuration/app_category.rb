FactoryBot.define do
  factory :app_category, class: 'BxBlockApiConfiguration::AppCategory' do
    app_type { "android" }
    feature_graphic { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Bold.jpg'), 'image/jpg') }
    product_title { "App Category" }
    app_category { "Ecom" }
    review_username { "username" }
    review_password { "Test@123" }
    review_notes { "Category notes" }

    association :app_submission_requirement, factory: :app_submission_requirement
  end
end
