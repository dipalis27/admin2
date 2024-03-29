module BxBlockCourse
	class LessonsController < ApplicationController
		before_action :set_lesson , only: [:update, :destroy, :show]

		def index
			lesson = BxBlockCourse::Lesson.all 
			if lesson.present?
				render json: BxBlockCourse::LessonSerializer.new(lesson).serializable_hash, status: :ok
			else
				render json: { error: "Lesson not found." }, status: 404
			end
		end

		def create
			lesson = BxBlockCourse::Lesson.create(lesson_params)
			if lesson.present?
				render json: BxBlockCourse::LessonSerializer.new(lesson, meta: {message: 'Lesson created successfully.'
				}).serializable_hash, status: :ok
			else
				render json: { error: "Lesson not created." }, status: :not_found
			end
		end



		def show
			if @lesson.present?
				render json: BxBlockCourse::LessonSerializer.new(@lesson).serializable_hash, status: :ok
			else
				render json: { error: "Lesson not found." }, status: 404
			end
		end

		def update
			if @lesson.present? 
				@lesson.update(lesson_params)

				render json: BxBlockCourse::LessonSerializer.new(@lesson, meta: {message: 'Lesson update successfully.'
				}).serializable_hash, status: :ok
			else
				errors = @lesson.errors.full_messages
				render :json => {:errors => [{:lesson => errors.first}]},
				:status => :unprocessable_entity	
			end
		end

		def duplicate_lesson
			record = BxBlockCourse::Lesson.find_by(id: params[:data][:id])
			duplicate = record.dup 
			if duplicate.save
				render json: BxBlockCourse::LessonSerializer.new(duplicate, meta: {message: ' Duplicate lesson created successfully.'
				}).serializable_hash, status: :ok
			else
				render json:{message: "Duplicate lesson not created"}, status: :not_found
			end
		end

		def destroy
			if @lesson.present?
				@lesson.destroy
				render json: { success: true }, status: :ok
			else
				render json: { 'errors': @lesson.errors.full_messages }, status: :unprocessable_entity	
			end
		end

		private

		def lesson_params
			params.require(:data).permit(:lesson_title, :description, :select_type , :modulee_id , :youtube_url , :text, :title , :content , :make_this_a_prerequisite ,
			:enable_discussion_for_this_lesson , :pdf , :status)
		end

		def set_lesson
			@lesson = BxBlockCourse::Lesson.find(params[:id])
		end
	end
end
