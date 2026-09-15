class UserReadBookJobs < ApplicationJob
  queue_as :book_readers

  def perform(user_id, book_id)
    book_view = BookView.new(user_id: user_id, book_id: book_id)
    book_view.save! if book_view.valid?
    mail = UserMailer.welcome_email
    mailer = mail.message
    html_str = mailer.html_part ? mailer.html_part.body.decoded : mailer.body.decoded
    byte_size = html_str.bytesize
    mail.deliver_now
    puts "[users:#{user_id}_books:#{book_id}] #{book_view.errors.messages}"
    File.open("output.html", "w") do |f|
      f.write(html_str)
    end
    puts "Email Body Size: #{byte_size} bytes (#{(byte_size / 1024.0)} KB)"
  end
end
