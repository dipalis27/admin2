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
      image_path="tmp/temp_image_#{Faker::Number.unique.number(digits: 4)}.#{image_extension}"
      File.open(image_path, 'wb') do |f|
        f.write(Base64.decode64(decoded_data))
      end
      [image_path, image_extension]
    end

    def set_image(object, base64, image)
      return object if base64.nil?
      unless base64.blank?
        image_path, image_extension = store_base64_image(base64)
        object.send(image).attach(io: File.open(image_path), filename: "image.#{image_extension}")
        File.delete(image_path) if File.exist?(image_path)
      else
        object.send(image).detach
      end
      object
    end
  end
end
