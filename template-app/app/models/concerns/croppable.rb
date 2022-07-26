module Croppable
  extend ActiveSupport::Concern
  include BxBlockAdmin::ModelUtilities

  included do
    attr_reader :cropped_image
  end

  # def cropped_image=(val)
  #   return if val.blank?

  #   val= JSON.parse(val).values.last
  #   image_path='cropped_image.png'
  #   val.gsub!("data:image/png;base64,", "")
  #   File.open(image_path, 'wb') do |f|
  #     f.write(Base64.decode64(val))
  #   end
  #   self.logo.attach(io: File.open(image_path), filename: "logo.png")
  #   File.delete(image_path) if File.exist?(image_path)
  # end

  def cropped_image=(val)
    image_path, image_extension = store_base64_image(val)
    self.logo.attach(io: File.open(image_path),filename: "cropped_image.#{image_extension}")
    File.delete(image_path) if File.exist?(image_path)
  end
end
