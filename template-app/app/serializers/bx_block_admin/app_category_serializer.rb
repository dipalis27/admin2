module BxBlockAdmin
  class AppCategorySerializer < BuilderBase::BaseSerializer
    attributes :id, :product_title, :app_category, :review_username, :review_password,
      :review_notes, :app_type

    attribute :feature_graphic do |object|
      $hostname + Rails.application.routes.url_helpers.rails_blob_url(object.feature_graphic, only_path: true) if object.feature_graphic.attached?
    end

    attribute :screenshots do |object|
      AttachmentSerializer.new(object.attachments).serializable_hash
    end
  end
end
