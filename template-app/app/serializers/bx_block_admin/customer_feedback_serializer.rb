module BxBlockAdmin
  class CustomerFeedbackSerializer < BuilderBase::BaseSerializer
    attributes :id , :description, :customer_name, :position, :image
  end
end