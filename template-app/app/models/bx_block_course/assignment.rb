module BxBlockCourse
  class Assignment < ApplicationRecord
    belongs_to :lesson  , class_name: "BxBlockCourse::Lesson"
    has_one_attached :pdf
  end
end