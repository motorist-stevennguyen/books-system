class ApplicationMailer < ActionMailer::Base
  GMAIL_CLIP_LIMIT_BYTES = 102.kilobytes

  default from: ENV.fetch("MAILER_ADDRESS")
  layout "mailer"
end
