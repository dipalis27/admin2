module BxBlockAdmin
	module V1
		class SubjectsController < ApplicationController
			before_action :set_subject , only: [:update, :destroy, :show]

			def index
				subject = BxBlockSubject::Subject.all 
				if subject.present?
					render json: BxBlockSubject::SubjectSerializer.new(subject).serializable_hash, status: :ok
				else
					render json: { error: subject.errors.full_messages }, status: 404
				end
			end

			def create
				subject = BxBlockSubject::Subject.create(subject_params)
				if subject.present?
					render json: BxBlockSubject::SubjectSerializer.new(subject).serializable_hash, status: :ok
				else
					render json: { error: subject.errors.full_messages }, status: 404
				end
			end

			def show
				if @subject.present?
					render json: BxBlockSubject::SubjectSerializer.new(@subject).serializable_hash, status: :ok
				else
					render json: { error: @subject.errors.full_messages }, status: 404
				end
			end

			def update
				if @subject.present? 
					@subject.update(subject_params)
					render json: BxBlockSubject::SubjectSerializer.new(@subject, meta: {message: 'subject update successfully.'
					}).serializable_hash, status: :ok
				else
					errors = @subject.errors.full_messages
					render :json => {:errors => [{:subject => errors.first}]},
					:status => :unprocessable_entity	
				end
			end

			def destroy
				if @subject.present?
					@subject.destroy
					render json: { success: true }, status: :ok
				else
					render json: { 'errors': @subject.errors.full_messages }, status: :unprocessable_entity	
				end
			end

			private

			def subject_params
				params[:data].permit(:subject_name)
			end

			def set_subject
				@subject = BxBlockSubject::Subject.find(params[:id])
			end
		end
	end
end