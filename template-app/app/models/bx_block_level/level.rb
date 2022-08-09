module BxBlockLevel
  class Level < BxBlockLevel::ApplicationRecord
    self.table_name = :levels
    
    validates :level_name, :presence => true, :uniqueness => true

    has_many :course_levels, class_name: 'BxBlockCourse::CourseLevel'
    has_many :courses, through: :course_levels, class_name: "BxBlockCourse::CourseLevel"
  end
end