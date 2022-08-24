module BxBlockFileUpload
  class Attachment < BxBlockFileUpload::ApplicationRecord
    self.table_name = :attachments

    belongs_to :attachable, polymorphic: true
    has_one_attached :image
    after_save :set_default_image

    attr_accessor :from_csv, :cropped_image

    # validates :image, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg'], if: -> { attachable_type == "BxBlockCatalogue::Catalogue" && Rails.env != 'test' && self.from_csv != true }
    validates :image, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg'], if: -> { attachable_type == "Banner" && attachable.web_banner == true }
    validates :image, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg'], if: -> { attachable_type == "Banner"&& attachable.web_banner == false }
    validate :validate_image

    def cropped_image=(val)
      @cropped_image = val
      return if val.blank?

      image_path, image_extension = store_base64_image(val)
      self.image.attach(io: File.open(image_path), filename: "cropped_image.#{image_extension}")
      File.delete(image_path) if File.exist?(image_path)
    end

    def changed_for_autosave?
      super || (self.image.present? && image.changed_for_autosave?)
    end

    def set_default_image
      return unless self.attachable_type == "BxBlockCatalogue::CatalogueVariant" || self.attachable_type == "BxBlockCatalogue::Catalogue"
      if self.is_default?
        attachments = self.attachable.attachments.where.not(id: self.id)
        attachments.update_all(is_default: false)
      else
        attachments = self.attachable.attachments.where(is_default: true)
        self.attachable.attachments.first.update(is_default: true) if attachments.blank?
      end
    end

    private

    def validate_image(*args)
      image_size = FastImage.size(self.attachment_changes['image'].attachable) rescue nil
      return true unless image_size.present?
      attributes = nil
      # if attachable_type == "BxBlockCatalogue::Catalogue" && Rails.env != 'test' && self.from_csv != true
      #   attributes = BxBlockCatalogue::Catalogue::ATTACHMENT_SIZE
      if attachable_type == "Banner"
        if attachable.web_banner
          attributes = BxBlockBanner::Banner::ATTACHMENT_SIZE[:web_banner]
        else
          attributes = BxBlockBanner::Banner::ATTACHMENT_SIZE[:app_banner]
        end
      else
        return true
      end

      if (image_size[0] < attributes[:min_width] || image_size[0] > attributes[:max_width]) || (image_size[1] < attributes[:min_height] || image_size[1] > attributes[:max_height])
        errors.add(:image, "The selected file could not be uploaded. The minimum dimensions are #{attributes[:min_width]}x#{attributes[:min_height]} pixels. The maximum dimensions are #{attributes[:max_width]}x#{attributes[:max_height]} pixels.")
      end
    end
  end
end

