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
			@course = BxBlockCourse::Course.create(course_params)
			if @course.present?
				media_upload
				render json: BxBlockCourse::CourseSerializer.new(@course, serialization_options).serializable_hash, status: :ok
			end
		end

		def show
			if @course.present?
				render json: BxBlockCourse::CourseSerializer.new(@course).serializable_hash, status: :ok
			else
				render json: { error: "Course not found." }, status: 404
			end
		end

		def update
			if @course.present?
				media_upload
				@course.update(course_params)
				render json: BxBlockCourse::CourseSerializer.new(@course, serialization_options).serializable_hash, status: :ok	
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

		def media_upload
  		return if image_params.blank?
    	@course.image.attach({ io: StringIO.new(Base64.decode64(image_params[:image_url])),
                       content_type: 'image/jpg', filename: 'image' })
    end

    def image_params
    	params[:image].permit(:image_url)
    end

    def serialization_options
      { params: { host: request.protocol + request.host_with_port } }
    end
	end
end
