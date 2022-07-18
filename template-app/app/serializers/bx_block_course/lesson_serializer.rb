module BxBlockCourse
  class LessonSerializer < BuilderBase::BaseSerializer
    include JSONAPI::Serializer
    attributes *[
      :select_type,
      :lesson_title,
      :description,
      :pdf,
      :youtube_url,
      :text,
      :modulee_id
    ]
    attribute :pdf do |object|
        object.pdf.present? ? (Rails.env.production? ? object.pdf.service_url.split("?").first : Rails.application.routes.url_helpers.rails_blob_path(object.try(:pdf), only_path: true)) : 'No pdf'
    end
  end
end