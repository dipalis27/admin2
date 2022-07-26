module BxBlockCourse
class AssignmentSerializer
  include JSONAPI::Serializer
 attributes *[
      :modulee_id,
      :title,
      :description,
      :select_type,
      :make_this_a_prerequisite,
      :status,
      :enable_discussions_for_this_lesson
    ] 
    attribute :pdf do |object|
        object.pdf.present? ? (Rails.env.production? ? object.pdf.service_url.split("?").first : Rails.application.routes.url_helpers.rails_blob_path(object.try(:pdf), only_path: true)) : 'No pdf'
    end
end
end
