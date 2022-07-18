# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockCategoriesSubCategories
  class Category < BxBlockCategoriesSubCategories::ApplicationRecord
    self.table_name = :categories

    attr_accessor :from_csv, :cropped_image

    has_one_attached :image

    # validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg'], attached: true, if: -> { Rails.env != 'test' && self.from_csv != true }
    # validate :validate_image, if: -> { Rails.env != 'test' && self.from_csv != true }

    # has_one :catalogue, class_name: 'BxBlockCatalogue::Catalogue'

    # has_and_belongs_to_many :sub_categories, join_table: :categories_sub_categories
    has_many :sub_categories, dependent: :destroy

    accepts_nested_attributes_for :sub_categories, allow_destroy:  true

    validates_presence_of :name
    validates_uniqueness_of :name, :message => '%{value} has already been taken'

    scope :latest, -> { order(created_at: :desc) }

    scope :enabled, -> {where(disabled: false) }

    after_create :track_event
    after_commit :update_onboarding_step

    def track_event
      Analytics.track(user_id: ENV["HOST_URL"].split("-")[1],event: 'New categories Created')
    end

    def cropped_image=(val)
      @cropped_image = val
      return if val.blank?

      image_path, image_extension = store_base64_image(val)
      self.image.attach(io: File.open(image_path), filename: "cropped_image.#{image_extension}")
      File.delete(image_path) if File.exist?(image_path)
    end

    private

    def validate_image
      image_size = FastImage.size(self.attachment_changes['image'].attachable) rescue nil
      return true unless image_size.present?
      if (image_size[0] < 120 || image_size[0] > 800) || (image_size[1] < 120 || image_size[1] > 800)
        errors.add(:image, "The selected file could not be uploaded. The minimum dimensions are 120x120 pixels. The maximum dimensions are 800x800 pixels.")
      end
    end

    def update_onboarding_step
      step_update_service = BxBlockAdmin::UpdateStepCompletion.new('categories', self.class.to_s)
      step_update_service.call
    end
  end
end
