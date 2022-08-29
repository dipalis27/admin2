class ApplicationRecord < ActiveRecord::Base
  include UrlUtilities
  self.abstract_class = true
end
