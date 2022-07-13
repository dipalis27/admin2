require 'spec_helper'
require 'rails_helper'

RSpec.describe BxBlockCatalogue::Brand, type: :model do
  subject { FactoryBot.build(:brand) }
  
  context "validation on brand model" do
    it { should validate_presence_of(:name) }
    
    it { should validate_uniqueness_of(:name) }
  
    it 'should have errors, if a object is not valid' do
      brand = described_class.new
      brand.valid?
      expect(brand.errors).not_to be_empty
    end
  end

end

