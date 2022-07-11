module BxBlockAdmin
  module ModelUtilities
    def attach_image(object, base64, filename)
      attachment = {
        io: StringIO.new(Base64.decode64(base64)), filename: filename
      }
      object.image.attach(attachment)
      object
    end
  end
end
