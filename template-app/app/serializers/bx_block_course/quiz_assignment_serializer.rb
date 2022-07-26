module BxBlockCourse
  class QuizAssignmentSerializer

    include JSONAPI::Serializer
    attributes *[
      :course_id,
      :module_title
    ] 

    attribute :quizzes do |object, params|
      if object.present?
        BxBlockCourse::QuizSerializer.new(
          object.quizzes, { params: params }
          ).serializable_hash[:data]
      end
    end
    
    attribute :assignments do |object, params|
      if object.present?
        BxBlockCourse::AssignmentSerializer.new(
          object.assignments, { params: params }
          ).serializable_hash[:data]
      end
    end
  end
end
