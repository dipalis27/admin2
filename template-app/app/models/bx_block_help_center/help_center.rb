module BxBlockHelpCenter
  class HelpCenter < ApplicationRecord
    self.table_name = :help_centers

    validates_presence_of :title, :description, :help_center_type
    validates_uniqueness_of :help_center_type

    # Enum values
    ALL_STATES = %w[ other about_us terms_of_service privacy_policy how_it_works delivery_and_returns ].freeze
    enum help_center_type: ALL_STATES.zip(ALL_STATES).to_h
    enum status: %w[not_published published]

    # Callbacks
    before_create :track_event

    def track_event
      Analytics.track(user_id: ENV["HOST_URL"].split("-")[1],event: 'New Help Centre Created')
    end
  end
end
