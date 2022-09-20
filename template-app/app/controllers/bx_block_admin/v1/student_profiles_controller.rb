module BxBlockAdmin
  module V1
    class StudentProfilesController < ApplicationController
      before_action :student_profile, only: [:show, :update, :destroy]

      def index
        per_page = params[:per_page].present? ? params[:per_page].to_i : 10
        current_page = params[:page].present? ? params[:page].to_i : 1
        students =
          if params[:search_term].present?
            BxBlockStudentsData::StudentProfile.where("student_name ILIKE (?) or student_email ILIKE (?)", "%#{params[:search_term]}%", "%#{params[:search_term]}%")
          else
            BxBlockStudentsData::StudentProfile.all
          end
        students = students.order(created_at: :desc).page(current_page).per(per_page)
        render json: BxBlockStudentsData::StudentSerializer.new(students, pagination_data(students, per_page)).serializable_hash, status: :ok
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
