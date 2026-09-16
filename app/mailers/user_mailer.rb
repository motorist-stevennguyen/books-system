class UserMailer < ApplicationMailer
  default from: "notifications@example.com"

  NAME = "BookSystem"

  FEATURES = [
    { title: "Where can I get some?",
    price: "12.00$",
    description: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable" },
    { title: "Where does it come from?",
    price: "12.00$",
    description: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable" },
    { title: "What is Lorem Ipsum?",
    price: "12.00$",
    description: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable" },
    { title: "Why do we use it?",
      price: "12.00$",
      description: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable" },
    { title: "History, Purpose and Usage",
    price: "12.00$",
    description: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable" },
    { title: "Origins and Discovery",
    price: "12.00$",
    description: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable" }
  ].freeze

  def welcome_email(user)
    @user = user
    @url = "http://example.com/login"

    mail(to: "lcng00001@gmail.com", subject: "Welcome to #{NAME}")
    # mail.attachments["logo.jpg"] = File.read(File.join("app/assets/images", "logo.jpg"))
  end

  def clipping_demo(user, books)
    @user = user
    @url = "http://example.com/login"
    @books = books


    attachments.inline["logo.jpg"] = File.read(File.join("app/assets/images", "logo.jpg"))
    mail(to: "lcng00001@gmail.com", subject: "[BookSystem] Message Clipping")
  end
end
