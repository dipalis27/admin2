class ApplicationMailer < ActionMailer::Base
  add_template_helper(ActiveAdmin::ViewsHelper)
  
  default from: 'from@example.com'
  layout 'mailer'
end
