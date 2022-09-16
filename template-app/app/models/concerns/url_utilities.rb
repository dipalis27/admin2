module UrlUtilities
  extend ActiveSupport::Concern

  def url_for(file)
    base_url_utility + Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) if file.present?
  end

  def base_url_utility
    'https://' + (ENV['HOST_URL'] || ENV['BASE_URL'] || 'http://localhost:3000')
  end
end
