FactoryBot.define do
  factory :coupon_code, class: 'BxBlockCouponCodeGenerator::CouponCode' do
    title { 'Coupon' }
    description { 'Coupon description' }
    code { Faker::Code.unique.nric }
    discount_type { 'percentage' }
    discount { 30 }
    valid_from { Time.now + 1.day }
    valid_to { Time.now + 7.days }
    min_cart_value { 10 }
    max_cart_value { 100 }
    limit { 5 }
  end
end
