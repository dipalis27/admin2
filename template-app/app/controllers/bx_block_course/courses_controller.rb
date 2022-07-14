module BxBlockCourse
	class CoursesController < ApplicationController
		before_action :set_course, only: [:update, :destroy, :show]
		def index
			courses = BxBlockCourse::Course.all
			if courses.present?
				render json: BxBlockCourse::CourseSerializer.new(courses).serializable_hash, status: :ok
			end
		end 

		def create
			course = BxBlockCourse::Course.create(course_params)
			if course.present?
				render json: BxBlockCourse::CourseSerializer.new(course, meta: {message: 'Course created successfully.'
				}).serializable_hash, status: :ok
			end
		end

		def show
			if @course.present?
				render json: BxBlockCourse::CourseSerializer.new(@course).serializable_hash, status: :ok
			end	
		end

		def update
			if @course.present? 
				@course.update(course_params)
				render json: BxBlockCourse::CourseSerializer.new(@course, meta: {message: 'Course update successfully.'
				}).serializable_hash, status: :ok	
			else
				errors = @subscription.errors.full_messages
				render :json => {:errors => [{:course => errors.first}]},
				:status => :unprocessable_entity
			end
		end

		def destroy
			if @course.present? 
				@course.destroy
				render json: { success: true }, status: :ok
			else
				render json: { 'errors': @course.errors.full_messages }, status: :unprocessable_entity	
			end
		end

		private
		def course_params
			params.require(:data).permit(:course_name, :discription)
		end

		def set_course
			@course =  BxBlockCourse::Course.find(params[:id])
		end

	end
end
