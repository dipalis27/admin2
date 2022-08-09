module BxBlockCourse
  class CourseLevel < ApplicationRecord
  	self.table_name = :course_levels
  	belongs_to :level, class_name: 'BxBlockLevel::Level'
  	belongs_to :course
  end
end