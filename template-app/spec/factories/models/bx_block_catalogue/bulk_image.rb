FactoryBot.define do
  factory :bulk_image, class: BxBlockCatalogue::BulkImage do
    image { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/Logo.png'), 'image/png') }
  end
end
