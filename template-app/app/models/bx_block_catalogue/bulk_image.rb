module BxBlockCatalogue
  class BulkImage < BxBlockCatalogue::ApplicationRecord
    self.table_name = :bulk_images

    # Associations
    has_one_attached :image
    has_and_belongs_to_many :catalogues, class_name: 'BxBlockCatalogue::Catalogue',
                            join_table: 'catalogues_bulk_images', optional: true

    # Validations
    validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg'], attached: true

    def self.validate_and_save(images)
      response = {}
      BxBlockCatalogue::BulkImage.transaction do
        images.each do |image|
          BxBlockCatalogue::BulkImage.new(image: image).save!
        end
        response[:success] = true
        response[:message] = 'Images uploaded successfully.'
      rescue StandardError => e
        response[:success] = false
        response[:message] = e.message
        raise ActiveRecord::Rollback
      end
      response
    end
  end
end
