require 'rails_helper'

RSpec.describe BxBlockOrderManagement::Tax, type: :model do
  context 'Test cases for Tax' do
    it 'should be valid when all the fields are provided' do
      tax = FactoryBot.build(:tax)
      expect(tax).to be_valid
    end

    it 'should ensure presence of tax percentage' do
      tax = FactoryBot.build(:tax, tax_percentage: nil)
      expect(tax).to_not be_valid
    end
  end
end
