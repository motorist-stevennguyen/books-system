class ApplicationMailer < ActionMailer::Base
  GMAIL_CLIP_LIMIT_BYTES = 102.kilobytes

  default from: ENV.fetch("MAILER_ADDRESS")
  layout "mailer"

  after_action :warn_if_over_gmail_clip_limit

  private

  def warn_if_over_gmail_clip_limit
    part = message.html_part || message
    body = part&.body
    return unless body

    size = body.decoded.bytesize
    return if size <= GMAIL_CLIP_LIMIT_BYTES
  end
end
