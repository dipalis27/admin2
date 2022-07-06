FactoryBot.define do
  factory :tax, class: "BxBlockOrderManagement::Tax" do
    tax_percentage { Faker::Number.decimal_part(digits: 2) }
  end
end