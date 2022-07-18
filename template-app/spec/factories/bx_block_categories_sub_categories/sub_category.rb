FactoryBot.define do
  factory :sub_category, class: "BxBlockCategoriesSubCategories::SubCategory" do
    name { 'Sub Category 1' }
    disabled { false }
    image { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Bold.jpg'), 'image/jpg') }

    association :category, factory: :category
  end
end
