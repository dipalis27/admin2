module BxBlockCourse
	class CoursesController < ApplicationController
		def index
			courses = BxBlockCourse::Course.all
			if courses.present?
				render json: BxBlockCourse::CourseSerializer.new(courses, meta: {message: 'Course created successfully.'
				}).serializable_hash, status: :ok
			end
		end 

		def create
			course = BxBlockCourse::Course.create(course_params)
			if course.present?
				render json: BxBlockCourse::CourseSerializer.new(course, meta: {message: 'Course created successfully.'
				}).serializable_hash, status: :ok
			end
		end

		def update
			@course =  BxBlockCourse::Course.find(params[:id])
			if @course.update(course_params)
				render json: BxBlockCourse::CourseSerializer.new(@course, meta: {message: 'Course update successfully.'
				}).serializable_hash, status: :ok	
			else
				errors = @subscription.errors.full_messages
				render :json => {:errors => [{:course => errors.first}]},
				:status => :unprocessable_entity
			end
		end

		def destroy
			course = BxBlockCourse::Course.find_by(id: params[:id])
			if course.destroy
				render json: { success: true }, status: :ok
			else
				render json: {message: "not deleted"}, status: :ok	
			end
		end

		private
		def course_params
			params.require(:data).permit(:course_name, :discription)
		end

	end
end
