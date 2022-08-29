module BxBlockAdmin
  class ChangeAppSubmissionRequirement
    include BxBlockAdmin::ModelUtilities

    def initialize(requirement_params, image_params)
      @errors = []
      @paths = []
      @requirement_params = requirement_params
      @image_params = image_params
      @requirement = BxBlockApiConfiguration::AppSubmissionRequirement.first_or_initialize
    end

    def call
      assign_attributes_to_requirement
      @errors.push(@requirement.errors.full_messages) unless @requirement.save
      [@requirement, @errors.flatten, @paths]
    end

    def assign_attributes_to_requirement
      @requirement.assign_attributes(@requirement_params.except(:app_categories_attributes))
      
      if @image_params.present?
        @requirement = attach_image(@requirement, @image_params[:app_icon], 'app_icon')
        @requirement = attach_image(@requirement, @image_params[:common_feature_banner], 'common_feature_banner')
      end

      @requirement_params[:app_categories_attributes]&.each do |category_params|
        @requirement = assign_attributes_to_category(@requirement, category_params)
      end
    end

    def assign_attributes_to_category(requirement, category_params)
      if category_params[:id].present?
        category = requirement.app_categories.find_by(id: category_params[:id])
        return requirement if category.nil?
        if category_params[:_destroy].present? && category_params[:_destroy] == '1'
          category.destroy
          return requirement
        end
        category = set_category(category, category_params)
        @errors.push(category.errors.full_messages) unless category.save
        return requirement
      else
        category = requirement.app_categories.build
        category = set_category(category, category_params)
        return requirement
      end
    end

    def set_category(category, category_params)
      category.assign_attributes(category_params.except(:feature_graphic, :attachments_attributes))
      category = attach_image(category, category_params[:feature_graphic], 'feature_graphic')
      category_params[:attachments_attributes]&.each do |attachment_params|
        category = set_attachment(category, attachment_params)
      end
      category
    end

    def set_attachment(category, attachment_params)
      return category if attachment_params[:id].blank? && attachment_params[:image].nil?
      if attachment_params[:id].present?
        attachment = category.attachments.find_by(id: attachment_params[:id])
        return category if attachment.nil?
        if attachment_params[:_destroy].present? && attachment_params[:_destroy] == '1'
          attachment.destroy
          return category
        end
        attachment = attach_image(attachment, attachment_params[:image], 'image')
        @errors.push(attachment.errors.full_messages) unless attachment.save
        return category
      else
        attachment = category.attachments.build
        attachment = attach_image(attachment, attachment_params[:image], 'image')
        return category
      end
    end

    def attach_image(object, base64, image)
      return object if base64.nil?
      unless base64.blank?
        image_path, image_extension = store_base64_image(base64)
        object.send(image).attach(io: File.open(image_path), filename: "image.#{image_extension}")
        @paths << image_path
      else
        object.image.detach
      end
      object
    end
  end
end
