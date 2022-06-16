require 'rails_helper'

RSpec.describe BxBlockStoreProfile::BrandSetting do
  context  "validations for  brand_setting" do
    it 'should be valid if we provide all the fields' do
      brand_setting = FactoryBot.build(:brand_settings)
      expect(brand_setting).to be_valid
    end
    
    it 'ensures presence of heading' do
      brand_setting = FactoryBot.build(:brand_settings, heading: nil)
      expect(brand_setting).to_not be_valid
    end
    
    it 'ensures presence of logo ' do
      brand_setting = FactoryBot.build(:brand_settings,logo: nil)
      expect(brand_setting).to_not be_valid
    end
    
    it 'ensures presence of country' do
      brand_setting = FactoryBot.build(:brand_settings, country: nil)
      expect(brand_setting).to_not be_valid
    end

    it 'ensures length of heading' do
      brand_setting = FactoryBot.build(:brand_settings, heading: Faker::Lorem.question(word_count: 20))
      expect(brand_setting).to_not be_valid
    end

    it 'ensures valid phone_number' do
      brand_setting = FactoryBot.build(:brand_settings, phone_number: 98746541322)
      expect(brand_setting).to_not be_valid
    end
    
  end
end
