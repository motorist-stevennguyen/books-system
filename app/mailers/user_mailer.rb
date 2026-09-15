class UserMailer < ApplicationMailer
  default from: "notifications@example.com"

  def welcome_email
    @url  = "http://example.com/login"

    mail(to: "lcng00001@gmail.com", subject: "Welcome to My Awesome Site")
  end
end
