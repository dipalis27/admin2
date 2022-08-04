module BxBlockAdmin
  class QrCodeSerializer < BuilderBase::BaseSerializer
    attributes :id, :code_type, :url, :updated_at
  end
end
