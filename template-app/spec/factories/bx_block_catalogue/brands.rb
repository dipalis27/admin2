FactoryBot.define do
  factory :brand, class: "BxBlockCatalogue::Brand" do
    sequence(:name) { |times| "BRAND_#{times}_#{Time.now.to_i}" }
  end
end