module BxBlockAdmin
  module V1
    class BatchController < ApplicationController

      def process_request
        @batch = OpenStruct.new(batch_params)
        case @batch.action_type.try(:downcase)
          when "delete"
            delete_many
          else
            render json: { errors: ["Invalid action for batch to process."] }, status: :unprocessable_entity
        end
      end

      private

        def batch_params
          params.permit(:action_type, :resource, ids: [])
        end

        def delete_many
          case @batch.resource.try(:downcase)
            when "catalogues"
              process_delete_action(BxBlockCatalogue::Catalogue)
            when "brands"
              process_delete_action(BxBlockCatalogue::Brand)
            when "categories"
              process_delete_action(BxBlockCategoriesSubCategories::Category)
            when "taxes"
              process_delete_action(BxBlockOrderManagement::Tax)
            when "customers"
              process_delete_action(AccountBlock::Account)
            when "coupon_codes"
              process_delete_action(BxBlockCouponCodeGenerator::CouponCode)
            when "help_centers"
              process_delete_action(BxBlockHelpCenter::HelpCenter)
            when "email_templates"
              process_delete_action(BxBlockSettings::EmailSetting)
            when "admin_users"
              process_delete_action(AdminUser)
            when "zipcodes"
              process_delete_action(BxBlockZipcode::Zipcode)
            when "packages"
              process_delete_action(BxBlockOrderManagement::Package)
            when "push_notifications"
              process_delete_action(BxBlockNotification::PushNotification)
            when "customer_feedback"
              process_delete_action(BxBlockCatalogue::CustomerFeedback)
            when "catalogue_images"
              process_delete_action(BxBlockCatalogue::BulkImage)
            when "sub_admins"
              process_delete_action(AdminUser.sub_admin)
            else
              render json: { errors: ["Invalid resource for batch to process."] }, status: :unprocessable_entity
          end
        end

        def process_delete_action(resource_class)
          begin
            objects = resource_class.find(@batch.ids)
            result = []
            objects.each do |each_object|
              if each_object.destroy
                result << { status: 200, id: each_object.id }
              else
                result << { status: 422, id: each_object.id }
              end
            end
            render json: { message: "Deleted successfully.", result: result }, status: :ok  
          rescue => exception
            render json: { errors: [exception.message] }, status: :not_found
          end
        end

    end
  end
end
