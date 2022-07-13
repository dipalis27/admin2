require 'spec_helper'
require 'rails_helper'

RSpec.describe BxBlockSettings::EmailSetting, type: :model do
  subject { FactoryBot.build(:email_setting) }

  context 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
    it { should validate_presence_of(:content) }
  end

  it 'should return true as a default value' do
    expect(described_class.new.active).to eq(true)
  end
  
end
