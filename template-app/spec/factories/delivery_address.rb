FactoryBot.define do
  sequence :phone_number do |n|
    "+91" + rand(10**9..10**10).to_s
  end

  factory :delivery_address, class: 'BxBlockOrderManagement::DeliveryAddress' do
    name { "address name" }
    flat_no { "flat" }
    address { "complete address" }
    address_line_2 { "complete address 2" }
    city { "address city" }
    state { "address state" }
    country { "india" }
    zip_code { "452001" }
    phone_number { generate :phone_number }

    association :account, factory: :customer
  end
end
