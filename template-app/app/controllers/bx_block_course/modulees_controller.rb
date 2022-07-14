module BxBlockCourse
	class ModuleesController < ApplicationController
        before_action :set_modulee, only: [:update, :destroy]

        def index
        	modulee = BxBlockCourse::Modulee.all 
        	if modulee.present?
        	 render json: BxBlockCourse::ModuleeSerializer.new(modulee).serializable_hash, status: :ok
             end
        end

		def create
			modulee = BxBlockCourse::Modulee.create(modulee_params)
			if modulee.present?
				render json: BxBlockCourse::ModuleeSerializer.new(modulee, meta: {message: 'Module created successfully.'
				}).serializable_hash, status: :ok
			else
				render json:{message: "Module not created"}, status: :ok
			end
		end

		def duplicate
			record = BxBlockCourse::Modulee.find_by(id: params[:data][:id])
			duplicate = record.dup 
			if duplicate.save
				render json: BxBlockCourse::ModuleeSerializer.new(duplicate, meta: {message: ' Duplicate Module created successfully.'
				}).serializable_hash, status: :ok
			else
				render json:{message: "Duplicate module not created"}, status: :ok
			end
		end

		def update
			if @modulee.present? 
				@modulee.update(modulee_params)
				render json: BxBlockCourse::ModuleeSerializer.new(@modulee, meta: {message: 'Module update successfully.'
				}).serializable_hash, status: :ok	
			else
				errors = @modulee.errors.full_messages
				render :json => {:errors => [{:modulee => errors.first}]},
				:status => :unprocessable_entity
			end
		end

		def destroy
			 if @modulee.present?
			 @modulee.destroy
				render json: { success: true }, status: :ok
			else
				render json: {message: "not deleted"}, status: :ok	
			end
		end
		
		private
		def modulee_params
			params.require(:data).permit(:module_title, :course_id )
		end

		def set_modulee
			@modulee =  BxBlockCourse::Modulee.find(params[:id])
		end
	end
end
