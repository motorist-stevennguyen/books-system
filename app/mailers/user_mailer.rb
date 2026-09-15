class UserMailer < ApplicationMailer
  default from: "notifications@example.com"

  BRAND_NAME = "Foodie"

  FEATURES = [
    { title: "Recipe of the Week",
      description: "Fresh recipes picked by our editors, delivered every Monday." },
    { title: "Restaurant Deals",
      description: "Discounts at restaurants near you, updated weekly." },
    { title: "Personalized Meal Plans",
      description: "Meal plans based on your goals and dietary needs." },
    { title: "Grocery Delivery",
      description: "Order ingredients for tonight's recipe in two taps." },
    { title: "Cooking Tips & Tricks",
      description: "Short videos and notes from home cooks and chefs." },
    { title: "Dietary Preferences",
      description: "Tell us about allergies or diets like vegan or keto." }
  ].freeze

  def welcome_email(user)
    @user = user
    @url = "http://example.com/login"

    mail(to: "lcng00001@gmail.com", subject: "Welcome to #{BRAND_NAME}")
  end

  def clipping_demo(user, block_count: 51)
    @user = user
    @url = "http://example.com/login"
    @block_count = block_count

    mail(to: "lcng00001@gmail.com", subject: "[Demo] Gmail Message Clipping")
  end
end
