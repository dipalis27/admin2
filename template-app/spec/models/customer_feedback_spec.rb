require 'rails_helper'

RSpec.describe BxBlockCatalogue::CustomerFeedback, type: :model do
  context 'Test cases for customer feedback' do
    
    it 'should be valid if we provide all the fields' do
      feedback = FactoryBot.build(:customer_feedback)
      expect(feedback).to be_valid
    end

    it 'should be invalid if we does not provide description' do
      feedback = FactoryBot.build(:customer_feedback, description: nil)
      expect(feedback).to_not be_valid
    end

    it 'should be invalid if we does not provide customer_name' do
      feedback = FactoryBot.build(:customer_feedback, customer_name: nil)
      expect(feedback).to_not be_valid
    end

    it 'should be invalid if we does not provide position' do
      feedback = FactoryBot.build(:customer_feedback, position: nil)
      expect(feedback).to_not be_valid
    end

    it 'should validate the validate the uniqueness of position' do
      FactoryBot.create(:customer_feedback, position: 1)
      feedback = FactoryBot.build(:customer_feedback, position: 1)
      expect(feedback).to_not be_valid
    end
    
  end
  
end
