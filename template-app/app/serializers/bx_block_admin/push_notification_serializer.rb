module BxBlockAdmin

  class PushNotificationSerializer < BuilderBase::BaseSerializer
    attributes :id, :title, :message
  end
end