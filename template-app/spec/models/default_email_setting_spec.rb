require 'spec_helper'
require 'rails_helper'

RSpec.describe BxBlockSettings::DefaultEmailSetting, type: :model do
  
  context 'validation' do
    it { should validate_presence_of(:brand_name) }
    it { should validate_presence_of(:logo) }
    it { should validate_presence_of(:recipient_email) }
    it { should validate_presence_of(:contact_us_email_copy_to) }
  end

  it 'should be invalid object' do
    expect(described_class.new).not_to be_valid
  end

  it 'should be invalid object' do
    default_email_setting = FactoryBot.build(:default_email_setting)
    expect(default_email_setting).to be_valid
  end
  
end
