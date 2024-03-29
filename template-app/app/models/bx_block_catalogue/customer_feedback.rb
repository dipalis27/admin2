module BxBlockCatalogue
  class CustomerFeedback < BxBlockCatalogue::ApplicationRecord
    self.table_name = :customer_feedbacks

    VALID_IMAGE_FORMATS = %w(png jpg jpeg)
    belongs_to :catalogue, optional: true
    default_scope {order('position ASC')}

    validates_presence_of :description, :customer_name, :position
    validates_uniqueness_of :position

    has_one_attached :image
    after_create :track_event

    def track_event
      Analytics.track(user_id: ENV["HOST_URL"].split("-")[1],event: 'New Customer Feedback Created')
    end
  end
end
