require 'spec_helper'
require 'rails_helper'

RSpec.describe BxBlockCatalogue::Variant, type: :model do
  context 'when validating variant model' do
    it 'should be a valid object' do
      variant = FactoryBot.build(:variant)
      expect(variant).to be_valid
    end

    it 'should be invalid object for empty object' do
      expect(described_class.new).to be_invalid
    end

    it { should validate_presence_of(:name) }
  
    it { should have_many(:variant_properties) }
  end
end
