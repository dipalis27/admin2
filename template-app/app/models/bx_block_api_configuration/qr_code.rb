module BxBlockApiConfiguration
  class QrCode < ApplicationRecord
    self.table_name = :qr_codes
    enum code_type: ['android', 'ios']

    after_create :track_event

    validates_uniqueness_of :code_type
    validates_presence_of :code_type, :url

    def track_event
      Analytics.track(user_id: ENV["HOST_URL"].split("-")[1],event: 'New QR Code Generated')
    end
  end
end
