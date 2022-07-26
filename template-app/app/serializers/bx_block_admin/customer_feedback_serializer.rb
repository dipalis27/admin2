module BxBlockAdmin
  class CustomerFeedbackSerializer < BuilderBase::BaseSerializer
    attributes :id , :description, :customer_name, :position

    attribute :image do |object|
      $hostname + Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true) if object.image.attached?
    end
  end
end