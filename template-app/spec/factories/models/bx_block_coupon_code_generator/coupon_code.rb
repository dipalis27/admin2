FactoryBot.define do
  factory :coupon_code, class: BxBlockCouponCodeGenerator::CouponCode do
    title{Faker::Lorem.word}        
    description{Faker::Lorem.sentences}
    code{"ABCD"}
    discount_type{"flat"}
    discount{25.0}       
    valid_from{Date.today}     
    valid_to{Date.today + 10.days}       
    min_cart_value{500} 
    max_cart_value{5000}
  end
end