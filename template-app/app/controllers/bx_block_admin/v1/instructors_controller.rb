module BxBlockAdmin
  module V1
    class InstructorsController < ApplicationController
      before_action :set_instructor, only: [:show, :update, :destroy]

      def index
        per_page = params[:per_page].present? ? params[:per_page].to_i : 10
        current_page = params[:page].present? ? params[:page].to_i : 1
        instructors = BxBlockInstructorData::Instructor.order(updated_at: :desc).page(current_page).per(per_page)
        options = pagination_data(instructors, per_page)
        options[:params] = { host: request.protocol + request.host_with_port }
        render json: BxBlockInstructorsData::InstructorSerializer.new(instructors, options).serializable_hash, status: :ok
      end

      def create
        @instructor = BxBlockInstructorData::Instructor.new(instructor_params)
        if @instructor.save
          media_upload
          render json: BxBlockInstructorsData::InstructorSerializer.new(@instructor, serialization_options).serializable_hash, status: :ok
        else
          render json: {'errors' => [@instructor.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end

      def update
        if @instructor.present?
          media_upload
          @instructor.update(instructor_params)
          render json: BxBlockInstructorsData::InstructorSerializer.new(@instructor, serialization_options).serializable_hash, status: :ok
        else
          render json: {'errors' => [@instructor.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end

      def show
        if @instructor.present?
          render json: BxBlockInstructorsData::InstructorSerializer.new(@instructor, serialization_options).serializable_hash, status: :ok
        else
          render json: {'errors' => [@instructor.errors.full_messages.to_sentence]}, status: :not_found
        end
      end

      def destroy
        if @instructor.present?
          @instructor.destroy
          render json: { success: true }, status: :ok
        else
          render json: { 'errors': @instructor.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private 

        def instructor_params
          params.require(:data).permit(:instructor_name, :email)
        end

        def set_instructor
          @instructor =  BxBlockInstructorData::Instructor.find(params[:id])
        end

        def media_upload
          return if image_params.blank?
          @instructor.image.attach({ io: StringIO.new(Base64.decode64(image_params[:image_url])),
                           content_type: 'image/jpg', filename: 'image' })
        end

        def image_params
          params[:data].permit(:image_url)
        end

        def serialization_options
          { params: { host: request.protocol + request.host_with_port } }
        end
    end
  end
end
