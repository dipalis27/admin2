module BxBlockCourse
	class Course < ApplicationRecord
     	self.table_name = :courses
     	has_one_attached :image
		has_many :modulees, class_name: "BxBlockCourse::Modulee", dependent: :destroy

		has_many :courses_student_profiles, class_name: 'BxBlockCourse::CourseStudentProfile'
		has_many :student_profiles, through: :courses_student_profiles, class_name: "BxBlockStudentsData::StudentProfile"

		has_many :courses_instructors, class_name: 'BxBlockCourse::CourseInstructor'
		has_many :instructors, through: :courses_instructors, class_name: "BxBlockCourse::CourseInstructor"

		has_many :course_levels, class_name: 'BxBlockCourse::CourseLevel'
		has_many :levels, through: :course_levels, class_name: "BxBlockCourse::CourseLevel"
	end
end
