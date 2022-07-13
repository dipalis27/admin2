module BxBlockCourse
  class Modulee < ApplicationRecord
    self.table_name = :modulees
    belongs_to :course, class_name: "BxBlockCourse::Course"
  end
end
