FactoryBot.define do
  factory :zipcode, class: "BxBlockZipcode::Zipcode" do
    price_less_than {500}
    charge {50}
    code {'452001'}
    activated {true}
  end
end
