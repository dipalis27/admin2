FactoryBot.define do
  factory :shipping_charge, class: "BxBlockShippingCharge::ShippingCharge" do
    below {500}
    charge {50}
  end
end
