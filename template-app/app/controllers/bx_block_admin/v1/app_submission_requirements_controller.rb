module BxBlockAdmin
  module V1
    class AppSubmissionRequirementsController < ApplicationController
      include BxBlockAdmin::ModelUtilities

      def index
        render json: AppSubmissionRequirementSerializer.new(
          BxBlockApiConfiguration::AppSubmissionRequirement.first
        ).serializable_hash, status: :ok
      end

      def update
        requirement, errors, paths = ChangeAppSubmissionRequirement.new(requirement_params, image_params).call
        if requirement.save
          paths.compact.each{ |p| File.delete(p) if File.exist?(p) }
          render json: AppSubmissionRequirementSerializer.new(requirement).serializable_hash, status: :ok
        else
          render json: { 'errors': errors }, status: :unprocessable_entity
        end
      end

      private

      def requirement_params
        params.permit(
          :app_name, :short_description, :description,
          :website, :email, :phone, :first_name, :last_name, :country_name, :state, :city,
          :postal_code, :address,
          :privacy_policy_url, :support_url, :marketing_url, :terms_and_conditions_url,
          :target_audience_and_content,
          :is_paid, :default_price, :distributed_countries, :auto_price_conversion,
          :android_wear, :google_play_for_education, :us_export_laws, :copyright,
          app_categories_attributes: [
            :id, :_destroy, :app_type, :feature_graphic, :product_title, :app_category,
            :review_username, :review_password, :review_notes,
            attachments_attributes: [ :id, :image, :_destroy ]
          ], tags: []
        )
      end

      def image_params
        params.permit(:app_icon, :common_feature_banner)
      end
    end
  end
end
