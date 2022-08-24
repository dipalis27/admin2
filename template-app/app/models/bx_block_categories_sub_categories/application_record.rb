module BxBlockCategoriesSubCategories
  class ApplicationRecord < BuilderBase::ApplicationRecord
    include BxBlockAdmin::ModelUtilities
    self.abstract_class = true
  end
end
