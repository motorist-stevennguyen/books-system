class UserMailer < ApplicationMailer
  default from: "notifications@example.com"

  NAME = "BookSystem"

  def welcome_email(user)
    @user = user
    @url = "http://example.com/login"

    mail(to: "lcng00001@gmail.com", subject: "Welcome to #{NAME}")
  end

  def clipping_demo(user, books)
    @user = user
    @url = "http://example.com/login"
    @books = books


    attachments.inline["book.jpg"] = File.read(File.join("app/assets/images", "book.jpg"))
    mail(to: "lcng00001@gmail.com", subject: "[BookSystem] Message Clipping")
  end

  def clipping_demo_2(user, books)
    @user = user
    @url = "http://example.com/login"
    @books = books

    attachments.inline["book.jpg"] = File.read(File.join("app/assets/images", "book.jpg"))
    mail(to: "lcng00001@gmail.com", subject: "[BookSystem] Message Clipping (List Layout)")
  end
end
