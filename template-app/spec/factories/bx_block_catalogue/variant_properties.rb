FactoryBot.define do
  factory :variant_property, class: "BxBlockCatalogue::VariantProperty" do
    name { ["small", "medium", "large", "cotton", "linen", "polyster", "red", "green", "yellow"].take(1) }
  end
end