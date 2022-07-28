module BxBlockStoreProfile
  module Country
    extend ActiveSupport::Concern
    included do
      COUNTRIES = YAML.load_file("#{Rails.root}/config/countries.yml").keys.map{|code| code == 'in' ? 'india' : (code == 'gb' ? 'uk' : code) }
    end
  end
end
