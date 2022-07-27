module BxBlockAdmin
  module V1
    class StudentProfilesController < ApplicationController
      before_action :student_profile, only: [:show, :update, :destroy]

      def index
        @allstudent = BxBlockStudentsData::StudentProfile.all
        render json: BxBlockStudentsData::StudentSerializer.new(@allstudent).serializable_hash, status: :ok
      end

      def create
        student = BxBlockStudentsData::StudentProfile.new(student_params)
        if student.save
          render json: BxBlockStudentsData::StudentSerializer.new(student).serializable_hash, status: :ok
        else
          render json: {'errors' => [student.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end

      def update
        if @student.update(student_params)
          render json: BxBlockStudentsData::StudentSerializer.new(@student).serializable_hash, status: :ok
        else
          render json: {'errors' => [@student.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end

      def show
        if @student
          render json: BxBlockStudentsData::StudentSerializer.new(@student).serializable_hash, status: :ok
        else
          render json: {'errors' => ['Student not found']}, status: :not_found
        end
      end

      def destroy
        if @student
          @student.destroy
          render json: { message: "Student deleted successfully.", success: true}, status: :ok
        else
          render json: {'errors' => ['Student not found']}, status: :not_found
        end
      end

      private 

        def student_params
          params.permit(:student_name, :student_email, :level)
        end

        def student_profile
          @student = BxBlockStudentsData::StudentProfile.find_by_id(params[:id])
        end

        def course_params
          params[:data].permit(:student_id)
        end
    end
  end
end
