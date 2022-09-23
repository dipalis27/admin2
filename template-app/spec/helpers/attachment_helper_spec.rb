# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe AttachmentHelper, type: :helper do
  context "#attachment_hash" do
    it 'should respond to a method' do
      expect(helper).to respond_to(:attachment_hash)
    end

    it 'should return nil, if object is not there' do
      expect(helper.attachment_hash(nil,nil)).to be_nil
    end
  end
end
