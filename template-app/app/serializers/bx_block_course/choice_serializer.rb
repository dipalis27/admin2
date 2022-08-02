module BxBlockCourse
  class ChoiceSerializer
    include JSONAPI::Serializer
    attributes :id, :choice_title,  :is_correct_answer 
  end
end
