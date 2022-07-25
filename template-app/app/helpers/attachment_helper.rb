module AttachmentHelper

  def attachment_hash(attachment, hostname)
    return nil if attachment.nil? && hostname.nil? 
    {
      id: attachment.id,
      image_url: hostname + Rails.application.routes.url_helpers.rails_blob_url(attachment.image, only_path: true),
      is_default: attachment.is_default,
      created_at: attachment.created_at,
      updated_at: attachment.updated_at
    }
  end
end