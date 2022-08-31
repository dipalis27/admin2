class ApplicationMailer < ActionMailer::Base
  include UrlUtilities
  default from: 'from@example.com'
  layout 'mailer'
end
