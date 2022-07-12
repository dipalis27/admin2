module BxBlockCourse
	class ModuleesController < ApplicationController
		def new
			modulee = BxBlockCourse::Modulee.new(modulee_params)
			if modulee.save
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

		def destroy
			modulee = BxBlockCourse::Modulee.find_by(id: params[:id])
			if modulee.destroy
				render json: { success: true }, status: :ok
			else
				render json: {message: "not deleted"}, status: :ok	
			end
		end
		
		private

		def modulee_params
			params.require(:data).permit(:module_title, :course_id )
		end
	end
end
