require 'rails_helper'

RSpec.describe BxBlockCouponCodeGenerator::CouponCode, type: :model do
  context 'Coupon code' do

    it 'should be valid if we provide all the fields' do
      code = FactoryBot.build(:coupon_code)
      expect(code).to be_valid
    end

    it 'should ensures presence of title' do
      code = FactoryBot.build(:coupon_code, title: nil)
      expect(code).to_not be_valid
    end

    it 'should ensures presence of description' do
      code = FactoryBot.build(:coupon_code, description: nil)
      expect(code).to_not be_valid
    end

    it 'should ensures presence of code' do
      code = FactoryBot.build(:coupon_code, code: nil)
      expect(code).to_not be_valid
    end

    it 'should ensures presence of discount_type' do
      code = FactoryBot.build(:coupon_code, discount_type: nil)
      expect(code).to_not be_valid
    end

    it 'should ensures presence of discount' do
      code = FactoryBot.build(:coupon_code, discount: nil)
      expect(code).to_not be_valid
    end

    it 'should ensures presence of Valid date' do
      code = FactoryBot.build(:coupon_code, valid_from: Date.today-2.days)
      expect(code).to_not be_valid
    end

    it 'should ensures presence of valid_to' do
      code = FactoryBot.build(:coupon_code, valid_to: nil)
      expect(code).to_not be_valid
    end

    it 'should ensures the min_cart value is positive' do
      code = FactoryBot.build(:coupon_code, min_cart_value: -2500)
      expect(code).to_not be_valid
    end
    

    it 'should ensures the max_cart value is positive' do
      code = FactoryBot.build(:coupon_code, max_cart_value: -2500)
      expect(code).to_not be_valid
    end
  end
end
