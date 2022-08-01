module BxBlockCourse
	class QuizzesController < ApplicationController
		before_action :set_quiz , only: [:update, :destroy, :show]

		def index
			quiz = BxBlockCourse::Quiz.all 
			if quiz.present?
				render json: BxBlockCourse::QuizSerializer.new(quiz).serializable_hash, status: :ok
			else
				render json: { error: quiz.errors.full_messages }, status: 404
			end
		end

		def create
			quiz = BxBlockCourse::Quiz.create(quiz_params)
			if quiz.present?
				render json: BxBlockCourse::QuizSerializer.new(quiz, meta: {message: 'Quiz created successfully.'
				}).serializable_hash, status: :ok
			else
				render json: { error: "Quiz not created." }, status: :not_found
			end
		end

		def show
			if @quiz.present?
				render json: BxBlockCourse::QuizSerializer.new(@quiz).serializable_hash, status: :ok
			else
				render json: { error: @quiz.errors.full_messages }, status: 404
			end
		end

		def update
			if @quiz.present? 
				@quiz.update(quiz_params)
				render json: BxBlockCourse::QuizSerializer.new(@quiz, meta: {message: 'Quiz update successfully.'
				}).serializable_hash, status: :ok
			else
				errors = @quiz.errors.full_messages
				render :json => {:errors => [{:quiz => errors.first}]},
				:status => :unprocessable_entity	
			end
		end

		def duplicate_quiz
			record = BxBlockCourse::Quiz.find_by(id: params[:data][:id])
			duplicate = record.dup 
			if duplicate.save
				render json: BxBlockCourse::QuizSerializer.new(duplicate, meta: {message: ' Duplicate quiz created successfully.'
				}).serializable_hash, status: :ok
			else
				render json:{message: "Duplicate quiz not created"}, status: :not_found
			end
		end

		def destroy
			if @quiz.present?
				@quiz.destroy
				render json: { success: true }, status: :ok
			else
				render json: { 'errors': @quiz.errors.full_messages }, status: :unprocessable_entity	
			end
		end

		private

		def quiz_params
			params.require(:data).permit( :select_type, :quiz_title, :question_type, :make_this_a_prerequisite, :gradeable, :enable_discussions_for_this_lesson, 
				:modulee_id, :questions_attributes => [:id, :question_title, :description, choices_attributes: [ :choice_title , :is_correct_answer]])
		end

		def set_quiz
			@quiz = BxBlockCourse::Quiz.find(params[:id])
		end

		def question_params
			params.require(:data).permit \
			:id,
			:question_title,
			:description,
			choices_attributes: [:id , :choice_title , :is_correct_answer]
		end

		def choice_params
			params.require(:data).permit \
			:id, :choice_title, :is_correct_answer 
		end
	end
end