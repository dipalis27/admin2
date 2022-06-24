require 'rails_helper'

RSpec.describe BxBlockHelpCenter::HelpCenter, type: :model do
  context "test case for help center" do
    it 'should be valid when all the fields provided' do
      help_center = FactoryBot.build(:help_center)
      expect(help_center).to be_valid
    end
    
    it 'ensure presence of title' do
      help_center = FactoryBot.build(:help_center, title: nil)
      expect(help_center).to_not be_valid
    end

    it 'ensure presence of description' do
      help_center = FactoryBot.build(:help_center, description: nil)
      expect(help_center).to_not be_valid
    end

    it 'ensure presence of help_center_type' do
      help_center = FactoryBot.build(:help_center, help_center_type: nil)
      expect(help_center).to_not be_valid
    end
  end
end
