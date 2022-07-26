module BxBlockCourse
  class QuizSerializer
    include JSONAPI::Serializer
      attributes *[
      :modulee_id,
      :select_type,
      :quiz_title,
      :question,
      :question_type,
      :description,
      :choise,
      :make_this_a_prerequisite,
      :gradeable,
      :enable_discussions_for_this_lesson,
      :correct_answer,
      :status
    ]
  end
end