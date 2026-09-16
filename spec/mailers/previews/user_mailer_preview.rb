# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.welcome_email(preview_user)
  end

  # http://localhost:3000/rails/mailers/user_mailer/clipping_demo
  # Open this preview's HTML version directly in Gmail (forward it to a
  # Gmail address, or run UserMailer.clipping_demo(user).deliver_now) to see
  # the real "[Message clipped] View entire message" behavior.
  def clipping_demo
    UserMailer.clipping_demo(preview_user)
  end

  private

  def preview_user
    User.new(email: "preview@example.com", first_name: "Alex", last_name: "Doe")
  end
end
