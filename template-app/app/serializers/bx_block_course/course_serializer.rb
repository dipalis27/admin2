module BxBlockCourse
  class CourseSerializer < BuilderBase::BaseSerializer
     attributes *[
      :course_name,
      :discription,
      :is_private
    ]
    attribute :modulees do |object, params|
      if object.present?
        BxBlockCourse::ModuleeSerializer.new(
          object.modulees, { params: params }
          ).serializable_hash[:data]
      end
    end
    
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

    attribute :students do |object|
      object.student_profiles
    end

    attribute :instructors do |object, params|
      BxBlockInstructorsData::InstructorSerializer.new(object.instructors, { params: params })
    end
  end
end