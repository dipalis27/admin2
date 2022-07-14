module BxBlockCourse
  class Modulee < ApplicationRecord
    self.table_name = :modulees
    belongs_to :course, class_name: "BxBlockCourse::Course"
    has_many :lessons, class_name: "BxBlockCourse::Lesson"
  end
end
