module BxBlockCourse
  class CourseSerializer < BuilderBase::BaseSerializer
     attributes *[
      :course_name,
      :discription
    ]
    attribute :image do |object, params|
      host = params[:host] || ''

      if object.image.attached?
        {
          id: object.image.id,
          url: host + Rails.application.routes.url_helpers.rails_blob_url(
            object.image, only_path: true
          )
        }
      end
    end
  end
end