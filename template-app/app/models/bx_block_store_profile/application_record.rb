module BxBlockStoreProfile
  class ApplicationRecord < BuilderBase::ApplicationRecord
    include ActiveStorageSupport::SupportForBase64
    self.abstract_class = true
  end
end
