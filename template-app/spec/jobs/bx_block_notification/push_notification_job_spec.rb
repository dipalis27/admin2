# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe BxBlockNotification::PushNotificationJob, type: :job do
  describe '#perform_later' do
    it 'push notification job' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        BxBlockNotification::PushNotificationJob.perform_later
      }.to have_enqueued_job
    end
    
  end
  
end
