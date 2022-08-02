module BxBlockAdmin
  module V1
    class LevelsController < ApplicationController
      before_action :get_level, only: [:show, :update, :destroy]

      def index
        @levels = BxBlockLevel::Level.all
        render json: BxBlockLevel::LevelSerializer.new(@levels).serializable_hash, status: :ok
      end

      def create
        level = BxBlockLevel::Level.new(level_params)
        if level.save
          render json: BxBlockLevel::LevelSerializer.new(level).serializable_hash, status: :ok
        else
          render json: {'errors' => [level.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end

      def update
        if @level.update(level_params)
          render json: BxBlockLevel::LevelSerializer.new(@level).serializable_hash, status: :ok
        else
          render json: {'errors' => [@level.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end

      def show
        if @level
          render json: BxBlockLevel::LevelSerializer.new(@level).serializable_hash, status: :ok
        else
          render json: {'errors' => ['Level not found']}, status: :not_found
        end
      end

      def destroy
        if @level
          @level.destroy
          render json: { message: "Level deleted successfully.", success: true}, status: :ok
        else
          render json: {'errors' => ['Level not found']}, status: :not_found
        end
      end

      private 

        def level_params
          params.permit(:level_name)
        end

        def get_level
          @level = BxBlockLevel::Level.find_by_id(params[:id])
        end

        def course_params
          params[:data].permit(:level_id)
        end
    end
  end
end
