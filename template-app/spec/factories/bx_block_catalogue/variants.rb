FactoryBot.define do
  factory :variant, class: "BxBlockCatalogue::Variant" do
    name { ["Size", "Color", "Material"].take(1) }
    variant_properties { build_list(:variant_property, 1) }
  end
end