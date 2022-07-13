module BxBlockCourse
	class LessonsController < ApplicationController
		def create
			lesson = BxBlockCourse::Lesson.create(lesson_params)
			if lesson.present?
				render json: BxBlockCourse::LessonSerializer.new(lesson, meta: {message: 'Lesson created successfully.'
				}).serializable_hash, status: :ok
			end
		end
	end
	private
	def lesson_params
		params.require(:data).permit(:lesson_title, :discription , :vedio , :pdf)
	end
end
end
