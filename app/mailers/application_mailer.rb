class ApplicationMailer < ActionMailer::Base
  default from: Settings.default_email
end
