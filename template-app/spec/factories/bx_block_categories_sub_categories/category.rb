FactoryBot.define do
  factory :category, class: "BxBlockCategoriesSubCategories::Category" do
    name { 'Category 1' }
    disabled { false }
    image { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Bold.jpg'), 'image/jpg') }
  end
end
