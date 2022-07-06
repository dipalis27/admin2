module BxBlockCourse
	class CoursesController < ApplicationController
		def create
			course = BxBlockCourse::Course.create(course_params)
			if course.present?
				render json: BxBlockCourse::CourseSerializer.new(course, meta: {message: 'Course created successfully.'
				}).serializable_hash, status: :ok
			end
		end
		def course_params
			params.require(:course).permit \
			:course_name
		end

	end
end
