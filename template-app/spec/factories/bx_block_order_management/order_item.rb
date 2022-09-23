FactoryBot.define do
  factory :order_item, class: "BxBlockOrderManagement::OrderItem" do
    quantity {1}
    association :catalogue, factory: :catalogue
  end
end
