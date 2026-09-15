class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_ADDRESS")
  layout "mailer"
end
