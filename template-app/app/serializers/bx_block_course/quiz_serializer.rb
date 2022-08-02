module BxBlockCourse
  class QuizSerializer
    include JSONAPI::Serializer
    attributes *[
      :modulee_id,
      :select_type,
      :quiz_title,
      :make_this_a_prerequisite,
      :gradeable,
      :enable_discussions_for_this_lesson,
      :status
    ]

    attribute :questions do |object, params|
      QuestionSerializer.new(object.questions).serializable_hash[:data]
    end 
  end
end