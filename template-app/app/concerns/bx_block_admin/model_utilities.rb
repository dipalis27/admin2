module BxBlockAdmin
  module ModelUtilities
    def attach_image(object, base64, filename)
      attachment = {
        io: StringIO.new(Base64.decode64(base64)), filename: filename
      }
      object.image.attach(attachment)
      object
    end

    def store_base64_image(base64)
      image_extension = base64.split(',').first.gsub("\;base64", "").gsub("data:image/", '') rescue 'png'
      decoded_data = base64.gsub!("data:image/#{image_extension};base64,", "")
      image_path="tmp/temp_image.#{image_extension}"
      File.open(image_path, 'wb') do |f|
        f.write(Base64.decode64(decoded_data))
      end
      [image_path, image_extension]
    end
  end
end
