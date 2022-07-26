module BxBlockNotification
  class PushNotification < BxBlockNotification::ApplicationRecord
    self.table_name = :push_notifications

    # after_create :send_push_notification

    # Validation
    validates_presence_of :title, :message

    # def send_push_notification
    #   BxBlockNotification::SendPushNotification.new(self).call
    # end
  end
end
