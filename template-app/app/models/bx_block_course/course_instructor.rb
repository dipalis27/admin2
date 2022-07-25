module BxBlockCourse
  class CourseInstructor < ApplicationRecord
  	self.table_name = :course_instructors
  	belongs_to :instructor, class_name: 'BxBlockInstructorData::Instructor'
  	belongs_to :course
  end
end