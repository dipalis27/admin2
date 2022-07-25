module BxBlockCourse
  class CourseStudentProfile < ApplicationRecord
  	self.table_name = :courses_student_profiles
  	belongs_to :student_profile, class_name: 'BxBlockStudentsData::StudentProfile'
  	belongs_to :course
  end
 end