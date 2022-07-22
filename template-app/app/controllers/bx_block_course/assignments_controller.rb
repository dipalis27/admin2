module BxBlockCourse
	class AssignmentsController < ApplicationController
		before_action :set_assignment , only: [:update, :destroy, :show]
		
		def index
			assignment = BxBlockCourse::Assignment.all 
			if assignment.present?
				render json: BxBlockCourse::AssignmentSerializer.new(assignment).serializable_hash, status: :ok
			else
				render json: { error: "assignment not found." }, status: 404
			end
		end

		def create
			assignment = BxBlockCourse::Assignment.create(assignment_params)
			if assignment.present?
				render json: BxBlockCourse::AssignmentSerializer.new(assignment, meta: {message: 'Assignment created successfully.'
				}).serializable_hash, status: :ok
			else
				render json: { error: "Assignment not created." }, status: 404	
			end
		end 

		def update
			if @assignment.present? 
				@assignment.update(assignment_params)
				render json: BxBlockCourse::AssignmentSerializer.new(@assignment, meta: {message: 'assignment update successfully.'
				}).serializable_hash, status: :ok
			else
				errors = @assignment.errors.full_messages
				render :json => {:errors => [{:assignment => errors.first}]},
				:status => :unprocessable_entity	
			end
		end

		def show
			if @assignment.present?
				render json: BxBlockCourse::AssignmentSerializer.new(@assignment).serializable_hash, status: :ok
			else
				render json: { error: "Assignment not found." }, status: 404
			end
		end

		def destroy
			if @assignment.present?
				@assignment.destroy
				render json: { success: true }, status: :ok
			else
				render json: { 'errors': @assignment.errors.full_messages }, status: :unprocessable_entity	
			end
		end

		def duplicate_assignment 
			record = BxBlockCourse::Assignment.find_by(id: params[:data][:id])
			duplicate = record.dup   
			if duplicate.save
				render json: BxBlockCourse::AssignmentSerializer.new(duplicate, meta: {message: ' Duplicate Assignment created successfully.'
				}).serializable_hash, status: :ok
			else
				render json:{message: "Duplicate assignment not created"}, status: :not_found
			end
		end

		private 
		def assignment_params 
			params.require(:data).permit(:title, :description, :select_type , :lesson_id , :pdf , :make_this_a_prerequisite , :status , :enable_discussions_for_this_lesson)
		end

		def set_assignment
			@assignment = BxBlockCourse::Assignment.find(params[:id])
		end
	end
end
