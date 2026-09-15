class UserReadBookJobs < ApplicationJob
  queue_as :book_readers

  def perform(user_id, book_id)
    book_view = BookView.new(user_id: user_id, book_id: book_id)
    book_view.save! if book_view.valid?

    user = User.find(user_id)
    
    mail = UserMailer.clipping_demo(user)
    mailer = mail.message
    html_str = mailer.html_part ? mailer.html_part.body.decoded : mailer.body.decoded
    byte_size = html_str.bytesize
    
    mail.deliver_now
    
    File.open("output.html", "w") do |f|
      f.write(html_str)
    end

    Rails.logger.info(
      "[UserReadBookJobs - #{byte_size} bytes (#{(byte_size / 1024.0)} KB)] user_id=#{user_id} book_id=#{book_id} errors=#{book_view.errors.messages}"
    )
  end
end
