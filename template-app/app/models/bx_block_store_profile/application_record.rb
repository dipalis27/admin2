module BxBlockStoreProfile
  class ApplicationRecord < BuilderBase::ApplicationRecord
    include ActiveStorageSupport::SupportForBase64
    include BxBlockAdmin::ModelUtilities

    self.abstract_class = true
  end
end
