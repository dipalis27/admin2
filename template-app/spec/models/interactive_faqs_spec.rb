require 'rails_helper'

RSpec.describe BxBlockInteractiveFaqs::InteractiveFaqs, type: :model do
  context "Test cases for interactive_faqs" do
    it 'should be valid when all the fields are provided' do
      interactive_faqs = FactoryBot.build(:interactive_faqs)
      expect(interactive_faqs).to be_valid
    end
    
    it 'ensures presence of title' do
      interactive_faqs = FactoryBot.build(:interactive_faqs, title: nil)
      expect(interactive_faqs).to_not be_valid
    end

    it 'ensures presence of content' do
      interactive_faqs = FactoryBot.build(:interactive_faqs, content: nil)
      expect(interactive_faqs).to_not be_valid
    end
    
    it 'ensures uniqueness of title' do
      FactoryBot.create(:interactive_faqs, title: "TestTitle")
      interactive_faqs = FactoryBot.build(:interactive_faqs, title: "TestTitle")
      expect(interactive_faqs).to_not be_valid
    end
  end
end
